# Smart Travel Planning and Recommendation System

A comprehensive web-based platform that helps users plan their trips efficiently with personalized recommendations based on preferences, budget, and real-time travel data.

## 📋 Quick Setup

### Windows Users

#### Prerequisites
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

#### Setup Options
1. **Automated Setup (Recommended)**
   ```cmd
   git clone https://github.com/KomaiX512/SMARTTRAVEL.git
   cd SMARTTRAVEL
   auto_setup.bat
   ```
   This script will set up everything with default values and start the server.

2. **Interactive Setup**
   ```cmd
   git clone https://github.com/KomaiX512/SMARTTRAVEL.git
   cd SMARTTRAVEL
   setup.bat
   ```
   This script provides prompts and allows you to customize the installation.

### Linux/Mac Users

#### Prerequisites
1. **Install Python 3.8 or newer**
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install python3 python3-pip python3-venv

   # macOS (with Homebrew)
   brew install python3
   ```

2. **Install PostgreSQL**
   ```bash
   # Ubuntu/Debian
   sudo apt install postgresql postgresql-contrib

   # macOS
   brew install postgresql
   brew services start postgresql
   ```

#### Setup Options
1. **Automated Setup (Recommended)**
   ```bash
   git clone https://github.com/KomaiX512/SMARTTRAVEL.git
   cd SMARTTRAVEL
   chmod +x auto_setup.sh
   ./auto_setup.sh
   ```

2. **Interactive Setup**
   ```bash
   git clone https://github.com/KomaiX512/SMARTTRAVEL.git
   cd SMARTTRAVEL
   chmod +x setup.sh
   ./setup.sh
   ```

## 💻 Accessing the Application

After setup completes:

1. **Local Development**
   - Open your browser to: http://127.0.0.1:8000/
   - Admin dashboard: http://127.0.0.1:8000/admin-dashboard/
   - Django admin: http://127.0.0.1:8000/admin/

2. **Default Login Credentials**
   - Regular user: username `user1`, password `password123`
   - Admin user: username `admin`, password `admin`

## 🚀 Hosting the Application

### Production Hosting

The Smart Travel system includes scripts for hosting on a Linux server:

1. **Prepare your server**
   - Ensure PostgreSQL is installed and running
   - Clone the repository to your server

2. **Configure settings**
   - Update `travel_planner/travel_planner/settings.py`:
     - Set `DEBUG = False`
     - Update `ALLOWED_HOSTS` with your domain
     - Configure database settings for production

3. **Start the hosting service**
   ```bash
   cd SMARTTRAVEL/travel_planner
   chmod +x start_hosting.sh
   ./start_hosting.sh
   ```
   This will:
   - Collect static files
   - Apply migrations
   - Start the application with Gunicorn
   - Run in the background with a PID file for management

4. **Stop the hosting service**
   ```bash
   cd SMARTTRAVEL/travel_planner
   chmod +x stop_hosting.sh
   ./stop_hosting.sh
   ```

5. **Configure Nginx (recommended)**
   - Install Nginx: `sudo apt install nginx`
   - Create a configuration file in `/etc/nginx/sites-available/`
   - Set up a proxy to your Gunicorn server
   - Enable the site and restart Nginx

   Example Nginx configuration:
   ```nginx
   server {
       listen 80;
       server_name yourdomain.com;

       location /static/ {
           alias /path/to/SMARTTRAVEL/travel_planner/staticfiles/;
       }

       location /media/ {
           alias /path/to/SMARTTRAVEL/travel_planner/media/;
       }

       location / {
           proxy_pass http://127.0.0.1:8000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

## 🔧 Troubleshooting

- **Python command not found**
  - Windows: Make sure Python is added to PATH
  - Linux/Mac: Try using `python3` instead of `python`

- **Database connection issues**
  - Verify PostgreSQL is running
  - Check database settings in `settings.py`
  - Ensure password is correct

- **Port already in use**
  - Change the port: `python manage.py runserver 8080`

- **Migration errors**
  - Try resetting migrations: `python manage.py migrate --fake-initial`

- **Static files not loading in production**
  - Run `python manage.py collectstatic`
  - Check Nginx configuration

## 📝 Documentation

### User Documentation
For users and administrators, please refer to the detailed guides in the application's "About" and "Help" sections.

### Developer Documentation
For developers, a comprehensive technical documentation is available in [DEVELOPER_DOCUMENTATION.md](DEVELOPER_DOCUMENTATION.md). This includes:

- System architecture
- Database schema
- API endpoints
- Frontend implementation
- Development workflow
- Deployment instructions

## ✨ Features

- **User Management**
  - Registration, authentication, and profile management
  - Travel preferences and personalization

- **Destinations**
  - Browse and search destinations
  - Filter by region, budget, and activities
  - View detailed information with weather data

- **Trip Planning**
  - Create and manage trips
  - Build detailed itineraries
  - Accommodation booking
  - Transportation management

- **Bookings and Tickets**
  - Hotel and transportation booking
  - E-ticket generation
  - Payment tracking (simulation)

- **Reviews and Ratings**
  - Rate and review destinations, accommodations, and attractions
  - Read other users' reviews

- **Team and Contact**
  - About our team members
  - Contact form for inquiries
  - Company information

- **Admin Dashboard**
  - User statistics and analytics
  - Content management
  - Booking oversight

## 🔄 Recent Updates

- Added comprehensive developer documentation
- Created automated setup scripts for Windows and Linux
- Enhanced contact page with team member information and images
- Improved database handling with PostgreSQL support
- Added hosting scripts for production deployment
- Enhanced UI/UX with responsive design improvements

## 🛠 Technologies Used

- **Backend**: Django 5.2, Python 3.8+
- **Database**: PostgreSQL, Django ORM
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 5
- **APIs**: Visual Crossing Weather API
- **Real-time**: Django Channels, EventStream
- **Server**: Gunicorn, Nginx (production)
- **Utilities**: FontAwesome, jQuery

## 📂 Project Structure

```
SMARTTRAVEL/
├── auto_setup.bat          # Automated setup for Windows
├── auto_setup.sh           # Automated setup for Linux/Mac
├── setup.bat               # Interactive setup for Windows
├── setup.sh                # Interactive setup for Linux/Mac
├── DEVELOPER_DOCUMENTATION.md  # Technical documentation
├── README.md               # This file
└── travel_planner/         # Main Django project
    ├── travel_planner/     # Project configuration
    ├── users/              # User management app
    ├── destinations/       # Destinations app
    ├── bookings/           # Bookings & trips app
    ├── reviews/            # Reviews app
    ├── templates/          # HTML templates
    ├── static/             # Static files
    ├── media/              # User-uploaded content
    ├── manage.py           # Django management script
    ├── start_hosting.sh    # Production hosting script
    ├── stop_hosting.sh     # Stop hosting script
    └── sample_data.py      # Sample data loader
```

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgements

- Weather data provided by [Visual Crossing Weather API](https://www.visualcrossing.com/)
- Images from [Unsplash](https://unsplash.com/)
- Icons from [FontAwesome](https://fontawesome.com/)
- UI framework by [Bootstrap](https://getbootstrap.com/) 