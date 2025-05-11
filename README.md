# Smart Travel Planning and Recommendation System

A web-based platform that helps users plan their trips efficiently with personalized recommendations based on user preferences, budget, and real-time travel data.

## 📋 Quick Setup for Windows Users

### Prerequisites
1. **Install Python 3.8 or newer**
   - Download from [python.org](https://www.python.org/downloads/)
   - ✅ **IMPORTANT**: Check "Add Python to PATH" during installation
   - Click "Install Now"

2. **Install Git**
   - Download from [git-scm.com](https://git-scm.com/download/win)
   - Use default installation options

3. **Install PostgreSQL**
   - Download from [postgresql.org](https://www.postgresql.org/download/windows/)
   - During installation:
     - Set password for postgres user to `postgres`
     - Keep default port (5432)
     - Complete the installation

### Setup Steps
1. **Open Command Prompt**
   - Press `Win+R`, type `cmd`, and press Enter

2. **Clone the Repository**
   ```cmd
   git clone https://github.com/KomaiX512/SMARTTRAVEL.git
   cd SMARTTRAVEL
   ```

3. **Run Automated Setup**
   ```cmd
   auto_setup.bat
   ```
   This script will:
   - Create a virtual environment
   - Install all dependencies
   - Create the PostgreSQL database
   - Set up the database schema
   - Load sample data
   - Create an admin user
   - Start the development server

4. **Access the Website**
   - Open your browser to: http://127.0.0.1:8000/
   - Admin dashboard: http://127.0.0.1:8000/admin-dashboard/

5. **Default Login Credentials**
   - Regular user: username `user1`, password `password123`
   - Admin user: username `admin`, password `admin`

### Troubleshooting
- **"'python' is not recognized as an internal or external command"**
  - Make sure Python is installed and added to PATH
  - Try using `py` instead of `python`

- **Database connection issues**
  - Verify PostgreSQL is running (check Services)
  - Make sure password is set to "postgres"

- **Port already in use**
  - Change the port: `python manage.py runserver 8080`

## For Linux/Mac Users

For non-Windows users, follow these alternatives:

### Option 1: Interactive Setup
```bash
# Clone the repository
git clone https://github.com/KomaiX512/SMARTTRAVEL.git
cd SMARTTRAVEL

# Run the interactive setup script
./setup.sh
```

### Option 2: Automated Setup
```bash
# Clone the repository
git clone https://github.com/KomaiX512/SMARTTRAVEL.git
cd SMARTTRAVEL

# Run the non-interactive setup script
./auto_setup.sh
```

## Manual Setup

If you prefer to set up the project manually, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/KomaiX512/SMARTTRAVEL.git
   cd SMARTTRAVEL/travel_planner
   ```

2. Create a virtual environment and activate it:
   - Windows: 
     ```cmd
     python -m venv venv
     venv\Scripts\activate
     ```
   - Mac/Linux:
     ```bash
     python3 -m venv venv
     source venv/bin/activate
     ```

3. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

4. Set up PostgreSQL:
   - Install PostgreSQL if not already installed
   - Create a database named 'travel_planner'
   - Set database settings in `travel_planner/settings.py`

5. Run migrations:
   ```
   python manage.py migrate
   ```

6. Load sample data:
   ```
   python manage.py shell < sample_data.py
   ```

7. Create a superuser:
   ```
   python manage.py createsuperuser
   ```

8. Run the development server:
   ```
   python manage.py runserver
   ```

## Features

- User registration and profile management
- Travel preference settings
- Destination discovery and recommendations
- Accommodation and attraction information
- Real-time weather information and forecasts
- Trip planning and itinerary creation
- Booking management
- User reviews and ratings
- Custom admin dashboard for site management

## Technologies Used

- Django 5.2 (Python web framework)
- PostgreSQL (Database)
- HTML/CSS (Frontend)
- Bootstrap 5 (UI Framework)
- Django Channels (Real-time functionality)
- Django EventStream (Server-Sent Events)

## Project Structure

- `users/`: User profiles and preferences
- `destinations/`: Destinations, accommodations, attractions, and weather
- `bookings/`: Trip planning and booking management
- `reviews/`: User reviews and ratings
- `travel_planner/`: Main project files and settings

## Key URLs

After starting the server, access these pages:

- Home page: http://127.0.0.1:8000/
- Admin dashboard: http://127.0.0.1:8000/admin-dashboard/
- Django admin: http://127.0.0.1:8000/admin/
- Destinations page: http://127.0.0.1:8000/destinations/

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Weather data provided by [Visual Crossing Weather API](https://www.visualcrossing.com/)
- Images from [Unsplash](https://unsplash.com/) 