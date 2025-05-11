#!/bin/bash

# SMART TRAVEL automated setup script
# Non-interactive version for CI/CD environments

set -e  # Exit on any error

# ANSI color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}====== $1 ======${NC}\n"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if the script is running in the correct directory
if [ ! -f "travel_planner/manage.py" ]; then
    print_error "This script must be run from the project root directory (containing the travel_planner directory)."
    exit 1
fi

# Navigate to the project directory
cd travel_planner
print_success "Navigated to travel_planner directory"

# Create virtual environment if it doesn't exist
print_header "Setting up virtual environment"
if [ ! -d "venv" ]; then
    python3 -m venv venv
    print_success "Created virtual environment"
else
    print_warning "Virtual environment already exists"
fi

# Activate virtual environment
source venv/bin/activate
print_success "Activated virtual environment"

# Install dependencies
print_header "Installing dependencies"
pip install --upgrade pip
print_success "Upgraded pip"

if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
    print_success "Installed requirements from requirements.txt"
else
    print_warning "requirements.txt not found, installing core dependencies"
    pip install django psycopg2-binary pillow django-channels django-eventstream
fi

# Install PostgreSQL if not already installed
print_header "Setting up PostgreSQL"
if ! command -v psql &> /dev/null; then
    print_warning "PostgreSQL not found, installing..."
    sudo apt-get update
    sudo apt-get install -y postgresql postgresql-contrib
    print_success "PostgreSQL installed"
else
    print_success "PostgreSQL is already installed"
fi

# Create PostgreSQL database and user
DB_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='travel_planner'" 2>/dev/null || echo "0")
if [ "$DB_EXISTS" != "1" ]; then
    sudo -u postgres psql -c "CREATE DATABASE travel_planner;"
    print_success "Created PostgreSQL database 'travel_planner'"
else
    print_warning "Database 'travel_planner' already exists"
fi

# Set password for postgres user
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"
print_success "Set password for PostgreSQL user"

# Grant privileges to postgres user
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE travel_planner TO postgres;"
print_success "Granted privileges to PostgreSQL user"

# Run database migrations
print_header "Running database migrations"
python manage.py migrate
print_success "Applied database migrations"

# Load sample data
print_header "Loading sample data"
python manage.py shell < sample_data.py
print_success "Loaded sample data"

# Create a default superuser (admin/admin)
print_header "Creating default superuser"
echo "from django.contrib.auth.models import User; User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | python manage.py shell
print_success "Created default superuser (username: admin, password: admin)"
print_warning "For security in production environments, change this password immediately!"

# Start development server
print_header "Starting development server"
print_success "Setup complete! Starting server at http://127.0.0.1:8000/"
print_warning "Press Ctrl+C to stop the server"
python manage.py runserver 