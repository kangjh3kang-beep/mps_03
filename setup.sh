#!/bin/bash
# MPS Ecosystem Setup Script
# Run this script to set up the entire ecosystem

set -e

echo "======================================"
echo "MPS Ecosystem Setup"
echo "======================================"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"

# Create .env file from template if not exists
if [ ! -f .env ]; then
    echo "📝 Creating .env from .env.development..."
    cp .env.development .env
    echo "⚠️  Please update .env with your actual credentials"
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p deploy/logs
mkdir -p deploy/backups
mkdir -p deploy/data

# Build services
echo "🔨 Building Docker images..."
docker-compose build

# Create networks if they don't exist
echo "🌐 Setting up networks..."
docker network create manpasik-network 2>/dev/null || true

echo ""
echo "======================================"
echo "✅ Setup Complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. Update .env file with your credentials"
echo "2. Run: docker-compose up -d"
echo "3. Check services: docker-compose ps"
echo "4. View logs: docker-compose logs -f"
echo ""
echo "API Gateway URL: http://localhost:8080"
echo "Admin Panel URL: http://localhost:9000"
echo ""
