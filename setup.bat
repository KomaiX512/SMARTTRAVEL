@echo off
:: SMART TRAVEL interactive setup script for Windows
:: This script automates the setup process for the Smart Travel project with user input

echo.
echo [94m====== SMART TRAVEL INTERACTIVE SETUP SCRIPT ======[0m
echo.

:: Check if the script is running in the correct directory
if not exist "travel_planner\manage.py" (
    echo [91mError: This script must be run from the project root directory.[0m
    echo [91mPlease make sure you are in the directory containing the travel_planner folder.[0m
    exit /b 1
)

:: Navigate to the project directory
cd travel_planner
echo [92mNavigated to travel_planner directory[0m

:: Create virtual environment if it doesn't exist
echo.
echo [94m====== Setting up virtual environment ======[0m
echo.

if not exist "venv\" (
    python -m venv venv
    echo [92mCreated virtual environment[0m
) else (
    echo [93mVirtual environment already exists[0m
)

:: Activate virtual environment
call venv\Scripts\activate
echo [92mActivated virtual environment[0m

:: Install dependencies
echo.
echo [94m====== Installing dependencies ======[0m
echo.

python -m pip install --upgrade pip
echo [92mUpgraded pip[0m

if exist "requirements.txt" (
    pip install -r requirements.txt
    echo [92mInstalled requirements from requirements.txt[0m
) else (
    echo [93mRequirements.txt not found, installing core dependencies[0m
    pip install django psycopg2-binary pillow django-channels django-eventstream
)

:: Check if PostgreSQL is installed
echo.
echo [94m====== Setting up PostgreSQL ======[0m
echo.

where psql >nul 2>&1
if %errorlevel% neq 0 (
    echo [93mPostgreSQL might not be installed or not in PATH[0m
    echo [93mPlease ensure PostgreSQL is installed and properly configured[0m
    echo [93mDownload from: https://www.postgresql.org/download/windows/[0m
    echo.
    set /p continue="Continue anyway? (y/n): "
    if /i "%continue%" neq "y" exit /b 1
) else (
    echo [92mPostgreSQL is installed[0m
)

:: Create database and setup privileges
echo.
echo [94m====== Setting up database ======[0m
echo.

:: We'll use psql to check if database exists and create it if needed
echo [93mTrying to create database if it doesn't exist...[0m
echo.

:: Create a temporary SQL file
echo SELECT 'CREATE DATABASE travel_planner' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'travel_planner')\gexec > create_db.sql

:: Run the SQL command
psql -U postgres -f create_db.sql
if %errorlevel% equ 0 (
    echo [92mDatabase check completed[0m
) else (
    echo [93mDatabase command failed. You may need to create the database manually.[0m
    echo [93mRun: createdb -U postgres travel_planner[0m
)

:: Delete temporary SQL file
del create_db.sql

:: Set password for postgres user
echo [93mSetting password for PostgreSQL user...[0m
echo ALTER USER postgres WITH PASSWORD 'postgres'; > set_password.sql
psql -U postgres -f set_password.sql
del set_password.sql

:: Run database migrations
echo.
echo [94m====== Running database migrations ======[0m
echo.

python manage.py migrate
echo [92mApplied database migrations[0m

:: Load sample data
echo.
echo [94m====== Loading sample data ======[0m
echo.

python manage.py shell < sample_data.py
echo [92mLoaded sample data[0m

:: Create superuser if needed
echo.
echo [94m====== Creating superuser ======[0m
echo.

set /p create_superuser="Do you want to create a superuser account? (y/n): "

if /i "%create_superuser%" == "y" (
    python manage.py createsuperuser
    echo [92mSuperuser created[0m
) else (
    echo [93mSkipped superuser creation[0m
    echo [93mYou can use the default sample users (username: user1, password: password123)[0m
    echo [93mOr create a superuser later with: python manage.py createsuperuser[0m
)

:: Start development server
echo.
echo [94m====== Starting development server ======[0m
echo.

set /p start_server="Do you want to start the development server now? (y/n): "

if /i "%start_server%" == "y" (
    echo [92mStarting server at http://127.0.0.1:8000/[0m
    echo [93mPress Ctrl+C to stop the server[0m
    python manage.py runserver
) else (
    echo [93mServer not started[0m
    echo [92mSetup complete! Run 'python manage.py runserver' to start the server.[0m
) 