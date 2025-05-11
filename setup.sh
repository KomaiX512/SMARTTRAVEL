#!/bin/bash

# SMART TRAVEL setup script
# This script automates the setup process for the Smart Travel project

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
print_warning "You may be prompted for your password to run PostgreSQL commands as postgres user"

# Check if database already exists
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

# Create superuser if needed
print_header "Creating superuser"
echo "Do you want to create a superuser account? (y/n)"
read -r create_superuser

if [ "$create_superuser" = "y" ] || [ "$create_superuser" = "Y" ]; then
    python manage.py createsuperuser
    print_success "Superuser created"
else
    print_warning "Skipped superuser creation"
    print_warning "You can use the default sample users (username: user1, password: password123)"
    print_warning "Or create a superuser later with: python manage.py createsuperuser"
fi

# Start development server
print_header "Starting development server"
echo "Do you want to start the development server now? (y/n)"
read -r start_server

if [ "$start_server" = "y" ] || [ "$start_server" = "Y" ]; then
    print_success "Starting server at http://127.0.0.1:8000/"
    print_warning "Press Ctrl+C to stop the server"
    python manage.py runserver
else
    print_warning "Server not started"
    print_success "Setup complete! Run 'python manage.py runserver' to start the server."
fi 