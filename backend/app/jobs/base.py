"""Base job class for background tasks"""
import asyncio
import logging
from abc import ABC, abstractmethod
from typing import Optional

logger = logging.getLogger(__name__)


class BaseJob(ABC):
    """Base class for background jobs"""

    def __init__(self, interval_seconds: int):
        """
        Initialize the job.

        Args:
            interval_seconds: How often to run the job (in seconds)
        """
        self.interval_seconds = interval_seconds
        self._task: Optional[asyncio.Task] = None
        self._running = False

    @abstractmethod
    async def execute(self) -> None:
        """Execute the job logic. Must be implemented by subclasses."""
        pass

    async def _run_loop(self) -> None:
        """Internal loop that runs the job at the specified interval"""
        logger.info(
            f"Starting {self.__class__.__name__} with {self.interval_seconds}s interval"
        )

        while self._running:
            try:
                await self.execute()
            except Exception as e:
                logger.error(
                    f"Error in {self.__class__.__name__}: {str(e)}",
                    exc_info=True
                )

            # Wait for the next interval
            await asyncio.sleep(self.interval_seconds)

    def start(self) -> None:
        """Start the background job"""
        if self._running:
            logger.warning(f"{self.__class__.__name__} is already running")
            return

        self._running = True
        self._task = asyncio.create_task(self._run_loop())
        logger.info(f"Started {self.__class__.__name__}")

    async def stop(self) -> None:
        """Stop the background job"""
        if not self._running:
            return

        self._running = False

        if self._task:
            self._task.cancel()
            try:
                await self._task
            except asyncio.CancelledError:
                pass

        logger.info(f"Stopped {self.__class__.__name__}")
