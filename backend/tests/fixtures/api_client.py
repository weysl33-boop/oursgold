"""API client wrapper using Playwright for CDP-based testing"""
import json
from typing import Dict, Any, Optional
from playwright.async_api import async_playwright, Browser, BrowserContext, Page
import pytest_asyncio


class CDPApiClient:
    """
    API client that uses Playwright's CDP capabilities to make HTTP requests
    and capture detailed performance metrics.
    """

    def __init__(self, base_url: str, page: Page):
        self.base_url = base_url
        self.page = page
        self.performance_data = []

    async def request(
        self,
        method: str,
        path: str,
        headers: Optional[Dict[str, str]] = None,
        json_data: Optional[Dict[str, Any]] = None,
        params: Optional[Dict[str, str]] = None,
    ) -> Dict[str, Any]:
        """
        Make an HTTP request using Playwright's page.evaluate to capture CDP metrics.

        Returns:
            Dict containing:
                - status: HTTP status code
                - data: Response JSON data
                - timing: Performance timing metrics (DNS, TCP, TLS, TTFB, download)
        """
        url = f"{self.base_url}{path}"

        # Build query string
        if params:
            query_string = "&".join([f"{k}={v}" for k, v in params.items()])
            url = f"{url}?{query_string}"

        # Prepare request options
        request_options = {
            "method": method.upper(),
            "headers": headers or {},
        }

        if json_data:
            request_options["body"] = json.dumps(json_data)
            request_options["headers"]["Content-Type"] = "application/json"

        # Use page.evaluate to make fetch request and capture performance
        result = await self.page.evaluate("""
            async ({ url, options }) => {
                const startTime = performance.now();

                try {
                    const response = await fetch(url, options);
                    const endTime = performance.now();

                    // Get response data
                    const contentType = response.headers.get('content-type');
                    let data = null;

                    if (contentType && contentType.includes('application/json')) {
                        data = await response.json();
                    } else {
                        data = await response.text();
                    }

                    // Get performance timing from Resource Timing API
                    const perfEntries = performance.getEntriesByType('resource');
                    const resourceTiming = perfEntries.find(entry => entry.name === url);

                    const timing = resourceTiming ? {
                        dns: resourceTiming.domainLookupEnd - resourceTiming.domainLookupStart,
                        tcp: resourceTiming.connectEnd - resourceTiming.connectStart,
                        tls: resourceTiming.secureConnectionStart > 0
                            ? resourceTiming.connectEnd - resourceTiming.secureConnectionStart
                            : 0,
                        ttfb: resourceTiming.responseStart - resourceTiming.requestStart,
                        download: resourceTiming.responseEnd - resourceTiming.responseStart,
                        total: endTime - startTime,
                    } : {
                        total: endTime - startTime,
                    };

                    return {
                        status: response.status,
                        statusText: response.statusText,
                        data: data,
                        timing: timing,
                        headers: Object.fromEntries(response.headers.entries()),
                    };
                } catch (error) {
                    return {
                        status: 0,
                        error: error.message,
                        timing: { total: performance.now() - startTime },
                    };
                }
            }
        """, {"url": url, "options": request_options})

        # Store performance data
        self.performance_data.append({
            "method": method,
            "path": path,
            "status": result.get("status"),
            "timing": result.get("timing", {}),
        })

        return result

    async def get(self, path: str, headers: Optional[Dict] = None, params: Optional[Dict] = None):
        """Make a GET request"""
        return await self.request("GET", path, headers=headers, params=params)

    async def post(self, path: str, json_data: Dict, headers: Optional[Dict] = None):
        """Make a POST request"""
        return await self.request("POST", path, headers=headers, json_data=json_data)

    async def put(self, path: str, json_data: Dict, headers: Optional[Dict] = None):
        """Make a PUT request"""
        return await self.request("PUT", path, headers=headers, json_data=json_data)

    async def delete(self, path: str, headers: Optional[Dict] = None):
        """Make a DELETE request"""
        return await self.request("DELETE", path, headers=headers)

    def get_performance_metrics(self) -> list:
        """Get all collected performance metrics"""
        return self.performance_data

    def get_average_response_time(self) -> float:
        """Calculate average response time across all requests"""
        if not self.performance_data:
            return 0.0

        total_time = sum(
            perf["timing"].get("total", 0)
            for perf in self.performance_data
        )
        return total_time / len(self.performance_data)

    def clear_performance_data(self):
        """Clear collected performance data"""
        self.performance_data = []


@pytest_asyncio.fixture
async def browser():
    """Create a Playwright browser instance"""
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        yield browser
        await browser.close()


@pytest_asyncio.fixture
async def browser_context(browser: Browser):
    """Create a new browser context for each test"""
    context = await browser.new_context(
        viewport={"width": 1920, "height": 1080},
        user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    )
    yield context
    await context.close()


@pytest_asyncio.fixture
async def page(browser_context: BrowserContext):
    """Create a new page for each test"""
    page = await browser_context.new_page()
    yield page
    await page.close()


@pytest_asyncio.fixture
async def api_client(page: Page):
    """Create CDP API client for testing"""
    base_url = "http://localhost:8000/api/v1"
    client = CDPApiClient(base_url, page)
    yield client
    # Performance data is automatically collected
