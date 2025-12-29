# Gold Social Platform - Backend API

FastAPI backend for the precious metals and forex social trading platform.

## Quick Start

### Prerequisites
- Python 3.11+
- Docker and Docker Compose (with containerd runtime)
- PostgreSQL 14+
- Redis 6+
- Kubernetes 1.24+ (for production deployment)

### Local Development with Docker

1. Copy environment file:
```bash
cp .env.example .env
```

2. Start all services:
```bash
docker-compose up -d
```

3. The API will be available at:
- API: http://localhost:8000
- API Docs: http://localhost:8000/api/docs
- ReDoc: http://localhost:8000/api/redoc

### Local Development without Docker

1. Create virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Run the application:
```bash
python -m app.main
```

## Testing

Run tests with coverage:
```bash
pytest
```

Run specific test file:
```bash
pytest tests/test_main.py
```

## Code Quality

Format code:
```bash
black app tests
isort app tests
```

Run linting:
```bash
pylint app
```

Run security check:
```bash
bandit -r app
```

## Project Structure

```
backend/
├── app/
│   ├── api/          # API routes
│   ├── services/     # Business logic
│   ├── repositories/ # Data access layer
│   ├── models/       # SQLAlchemy models
│   ├── schemas/      # Pydantic schemas
│   ├── core/         # Configuration
│   ├── websocket/    # WebSocket handlers
│   └── main.py       # FastAPI app
├── tests/            # Test suite
├── alembic/          # Database migrations
└── docker-compose.yml
```

## API Documentation

Once the server is running, visit:
- Swagger UI: http://localhost:8000/api/docs
- ReDoc: http://localhost:8000/api/redoc

## Environment Variables

See `.env.example` for all available configuration options.

## Database Migrations

Initialize Alembic (first time only):
```bash
alembic init alembic
```

Create a new migration:
```bash
alembic revision --autogenerate -m "description"
```

Apply migrations:
```bash
alembic upgrade head
```

## Containerization & Deployment

For detailed information about containerization with containerd and Kubernetes deployment:
- See [CONTAINERIZATION.md](./CONTAINERIZATION.md) for complete guide
- See [k8s/README.md](./k8s/README.md) for Kubernetes deployment

### Quick Deploy

**Local Development**:
```bash
docker-compose up -d
```

**Production (Kubernetes)**:
```bash
cd scripts
./build-and-push.sh
./deploy-k8s.sh
```

## License

Proprietary

