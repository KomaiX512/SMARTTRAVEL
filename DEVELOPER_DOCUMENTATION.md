# Smart Travel Planning and Recommendation System
## Developer Documentation

This document provides comprehensive technical documentation for developers working with the Smart Travel Planning and Recommendation System. It covers the system architecture, database design, frontend/backend functionality, and guides to common development tasks.

## Table of Contents
1. [System Overview](#system-overview)
2. [Architecture](#architecture)
3. [Database Structure](#database-structure)
4. [Backend Implementation](#backend-implementation)
5. [Frontend Implementation](#frontend-implementation)
6. [Authentication System](#authentication-system)
7. [API Services](#api-services)
8. [Development Workflow](#development-workflow)
9. [Common Tasks](#common-tasks)
10. [Deployment](#deployment)

## System Overview

Smart Travel is a Django-based web application that helps users plan and organize their travel experiences. The system provides personalized travel recommendations, destination information, accommodation and attraction listings, trip planning tools, and booking management.

### Key Features
- Destination browsing with search and filtering capabilities
- Accommodation and attraction listings with details
- User accounts and personalized preferences
- Trip planning and itinerary creation
- Booking management for accommodations and transportation
- Weather information integration
- User reviews and ratings
- Admin dashboard for analytics and management

## Architecture

The Smart Travel system follows a typical Django MVT (Model-View-Template) architecture:

```
travel_planner/                 # Main project directory
├── travel_planner/             # Project settings package
│   ├── settings.py             # Project settings
│   ├── urls.py                 # Main URL routing
│   ├── views.py                # Core views
│   └── wsgi.py & asgi.py       # WSGI/ASGI applications
├── templates/                  # HTML templates
│   ├── base/                   # Base templates (shared layouts)
│   └── app-specific templates  # Templates for each app
├── static/                     # Static files (CSS, JS, images)
├── media/                      # User-uploaded content
├── users/                      # User management app
├── destinations/               # Destinations app
├── bookings/                   # Bookings & trips app
├── reviews/                    # Reviews app
└── manage.py                   # Django management script
```

The system follows these architectural principles:
- **Separation of concerns**: Each Django app handles specific functionality
- **Reusable components**: Templates extend from base templates
- **RESTful routes**: URL patterns follow RESTful conventions
- **Database abstraction**: Django ORM handles database operations
- **User authentication**: Django's built-in auth system with custom extensions

## Database Structure

Smart Travel uses PostgreSQL as its primary database. The schema consists of multiple interconnected tables representing the core domain entities.

### Key Database Models

#### Users App
- **User**: Django's built-in user model (auth_user table)
- **UserProfile**: Extended user profile with additional details
  - Fields: user (FK), profile_picture, bio, phone_number
- **TravelPreference**: User travel preferences
  - Fields: user (FK), destination_type, budget_preference, travel_style, preferred_activities, dietary_restrictions

#### Destinations App
- **Destination**: Travel destinations
  - Fields: name, country, city, description, image, avg_temperature, best_time_to_visit, popularity_score
- **Accommodation**: Places to stay
  - Fields: destination (FK), name, type, address, price_per_night, rating, amenities, image
- **Attraction**: Things to do at destinations
  - Fields: destination (FK), name, category, description, entrance_fee, opening_hours, image

#### Bookings App
- **Trip**: User trip plans
  - Fields: user (FK), title, start_date, end_date, destination (FK), accommodation (FK), budget, notes, is_completed, created_at
- **Transportation**: Travel transportation details
  - Fields: trip (FK), type, provider, departure_location, arrival_location, departure_time, arrival_time, booking_reference, cost
- **Itinerary**: Day-by-day trip plan
  - Fields: trip (FK), day, date
- **ItineraryItem**: Activities in an itinerary
  - Fields: itinerary (FK), attraction (FK), custom_activity, start_time, end_time, notes
- **HotelBooking**: Accommodation booking details
  - Fields: trip (FK), accommodation (FK), check_in_date, check_out_date, guests, room_type, total_cost, booking_reference, booking_date, status, is_paid, special_requests
- **TransportationBooking**: Transportation booking details
  - Fields: trip (FK), transportation (FK), booking_date, booking_reference, passenger_names, status, is_paid
- **ETicket**: Electronic tickets for bookings
  - Fields: user (FK), trip (FK), ticket_type, hotel_booking (FK), transportation_booking (FK), ticket_number, issue_date, qr_code, additional_info
- **PaymentTransaction**: Payment transaction records
  - Fields: user (FK), booking_type, hotel_booking (FK), transportation_booking (FK), amount, payment_method, transaction_id, status, created_at, updated_at, card_last_digits

#### Reviews App
- **DestinationReview**: Reviews for destinations
  - Fields: user (FK), destination (FK), rating, comment, weather_rating, safety_rating, created_at
- **AccommodationReview**: Reviews for accommodations
  - Fields: user (FK), accommodation (FK), rating, comment, cleanliness_rating, service_rating, value_rating, created_at
- **AttractionReview**: Reviews for attractions
  - Fields: user (FK), attraction (FK), rating, comment, value_for_money, created_at

### Database Relationships

The database schema follows these relationship patterns:
- **One-to-One**: User to UserProfile (one user has one profile)
- **One-to-Many**: User to Trips (one user has many trips)
- **One-to-Many**: Destination to Accommodations (one destination has many accommodations)
- **One-to-Many**: Destination to Attractions (one destination has many attractions)
- **One-to-Many**: Trip to Itineraries (one trip has many daily itineraries)
- **Many-to-Many**: Trips to Attractions (via ItineraryItem)

### Working with the Database

The database can be accessed and manipulated through Django's ORM (Object-Relational Mapper):

```python
# Query examples
# Get all destinations
destinations = Destination.objects.all()

# Filter destinations by country
europe_destinations = Destination.objects.filter(country__in=['France', 'Italy', 'Spain'])

# Get a specific destination with its accommodations
destination = Destination.objects.get(id=1)
accommodations = destination.accommodations.all()  # Uses reverse relationship

# Create a new trip
new_trip = Trip.objects.create(
    user=request.user,
    title="Summer in Paris",
    start_date="2024-07-01",
    end_date="2024-07-10",
    destination=destination,
    budget=1500.00
)

# Update a record
accommodation = Accommodation.objects.get(id=1)
accommodation.price_per_night = 120.00
accommodation.save()

# Delete a record
trip = Trip.objects.get(id=1)
trip.delete()
```

## Backend Implementation

The backend is implemented using Django, a high-level Python web framework.

### App Structure

Each Django app is organized as follows:
- **models.py**: Database models and relationships
- **views.py**: View functions/classes that handle HTTP requests
- **urls.py**: URL routing configuration
- **admin.py**: Django admin interface configuration
- **tests.py**: Unit and integration tests
- **utils.py**: Utility functions and helpers
- **migrations/**: Database migration files

### Key Views and Functions

#### Destinations App
- **destination_list**: Shows all destinations with filtering options
- **destination_search**: Searches destinations by query
- **destination_detail**: Shows detailed information about a destination
- **accommodation_detail**: Shows detailed information about an accommodation
- **attraction_detail**: Shows detailed information about an attraction
- **destination_weather**: Gets current weather for a destination

#### Bookings App
- **trip_list**: Shows user's trips
- **trip_detail**: Shows detailed information about a trip
- **create_trip**: Creates a new trip
- **trip_itinerary**: Shows/manages trip itinerary
- **book_accommodation**: Handles accommodation booking
- **book_transportation**: Handles transportation booking
- **generate_e_ticket**: Creates e-tickets for bookings

#### Users App
- **register**: User registration
- **profile**: User profile management
- **update_preferences**: Updates user travel preferences
- **login/logout**: Authentication views

### Middleware and Settings

The project uses several important middleware components:
- **UserActivityMiddleware**: Tracks user activity for analytics
- **Django's built-in middleware**: For sessions, CSRF protection, etc.

Key settings in `settings.py`:
- **DATABASES**: PostgreSQL configuration
- **INSTALLED_APPS**: Installed Django apps
- **TEMPLATES**: Template engine configuration
- **STATIC_URL/MEDIA_URL**: Static and media file locations
- **AUTH_PASSWORD_VALIDATORS**: Password validation rules
- **LOGGING**: Logging configuration

## Frontend Implementation

The frontend is built using Django templates with Bootstrap 5, custom CSS, JavaScript, and various UI components.

### Template Structure

- **base/base.html**: Main layout template with navigation, footer, etc.
- **base/home.html**: Homepage template
- **base/about.html**: About page template
- **base/contact.html**: Contact page template
- **App-specific templates**: Templates for app-specific views

### Key Frontend Features

- **Responsive design**: Bootstrap 5 grid system for responsive layouts
- **Interactive UI components**: JavaScript-enhanced components
- **Form validation**: Client and server-side validation
- **CSS animations**: Smooth transitions and effects
- **AJAX interactions**: Dynamic content loading without page refresh
- **Custom styling**: Enhanced Bootstrap with custom styles
- **FontAwesome icons**: Used throughout the UI

### JavaScript Functionality

The system uses JavaScript for:
- Form validation
- Dynamic content loading
- Interactive maps
- Weather data visualization
- Date pickers and time inputs
- Trip planning interface
- Booking management
- Real-time notifications

## Authentication System

The authentication system extends Django's built-in authentication with custom functionality.

### Key Features
- User registration with email verification
- Login/logout functionality
- Password reset
- Profile management
- Extended user profiles
- Role-based permissions
- Activity tracking

### Working with Authentication

```python
# Check if user is authenticated
if request.user.is_authenticated:
    # Do something for authenticated users
else:
    # Handle anonymous users

# Get user profile
profile = request.user.userprofile

# Check user permissions
if request.user.has_perm('bookings.can_create_trip'):
    # User has permission to create trips
```

In templates:
```html
{% if user.is_authenticated %}
    <!-- Show content for logged in users -->
    Welcome, {{ user.username }}!
{% else %}
    <!-- Show content for anonymous users -->
    <a href="{% url 'users:login' %}">Login</a>
{% endif %}
```

## API Services

Smart Travel integrates with external APIs for enhanced functionality.

### Weather Data API
The system uses Visual Crossing Weather API to fetch real-time weather data for destinations:

```python
# Example API call from utils.py
def get_current_weather(location):
    api_key = settings.VISUALCROSSING_WEATHER_API_KEY
    url = f"https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/{location}/today?unitGroup=metric&include=current&key={api_key}&contentType=json"
    
    try:
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            current = data.get('currentConditions', {})
            return {
                'temperature': current.get('temp'),
                'condition': current.get('conditions'),
                'icon': current.get('icon'),
                'humidity': current.get('humidity'),
                'wind_speed': current.get('windspeed'),
            }
    except Exception as e:
        logger.error(f"Weather API error: {e}")
    
    return None
```

## Development Workflow

### Setting Up the Development Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/smarttravel.git
   cd smarttravel
   ```

2. Set up a virtual environment:
   ```bash
   # Linux/Mac
   python -m venv venv
   source venv/bin/activate
   
   # Windows
   python -m venv venv
   venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Set up PostgreSQL database:
   ```bash
   # Create database
   createdb travel_planner
   
   # Apply migrations
   python manage.py migrate
   ```

5. Load sample data:
   ```bash
   python manage.py shell < sample_data.py
   ```

6. Create a superuser:
   ```bash
   python manage.py createsuperuser
   ```

7. Run the development server:
   ```bash
   python manage.py runserver
   ```

### Code Structure and Standards

- **PEP 8**: Follow Python style guide
- **Django Best Practices**: Follow Django's recommended patterns
- **Commenting**: Document functions and complex logic
- **Testing**: Write tests for models and views

### Making Changes

1. Create a new branch for your feature:
   ```bash
   git checkout -b feature/new-feature-name
   ```

2. Make your changes to the codebase

3. Create or update database migrations if needed:
   ```bash
   python manage.py makemigrations
   ```

4. Apply migrations:
   ```bash
   python manage.py migrate
   ```

5. Run tests:
   ```bash
   python manage.py test
   ```

6. Commit your changes:
   ```bash
   git add .
   git commit -m "Add feature: description of changes"
   ```

7. Push your branch:
   ```bash
   git push origin feature/new-feature-name
   ```

8. Create a pull request for review

## Common Tasks

### Adding a New Model

1. Define the model in the app's `models.py`:
   ```python
   class NewModel(models.Model):
       name = models.CharField(max_length=100)
       description = models.TextField()
       created_at = models.DateTimeField(auto_now_add=True)
       
       def __str__(self):
           return self.name
   ```

2. Create and apply migrations:
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

3. Register in `admin.py`:
   ```python
   from django.contrib import admin
   from .models import NewModel
   
   @admin.register(NewModel)
   class NewModelAdmin(admin.ModelAdmin):
       list_display = ('name', 'created_at')
       search_fields = ('name', 'description')
   ```

### Creating a New View

1. Add a view function in `views.py`:
   ```python
   from django.shortcuts import render
   from .models import NewModel
   
   def new_model_list(request):
       objects = NewModel.objects.all()
       return render(request, 'app/new_model_list.html', {'objects': objects})
   ```

2. Add a URL pattern in `urls.py`:
   ```python
   from django.urls import path
   from . import views
   
   urlpatterns = [
       path('new-models/', views.new_model_list, name='new_model_list'),
   ]
   ```

3. Create a template in the appropriate directory:
   ```html
   {% extends 'base/base.html' %}
   
   {% block content %}
     <h1>New Models</h1>
     <div class="row">
       {% for object in objects %}
         <div class="col-md-4">
           <div class="card mb-4">
             <div class="card-body">
               <h5 class="card-title">{{ object.name }}</h5>
               <p class="card-text">{{ object.description }}</p>
             </div>
           </div>
         </div>
       {% empty %}
         <p>No items found.</p>
       {% endfor %}
     </div>
   {% endblock %}
   ```

### Adding a New Feature

1. Identify which app should contain the feature
2. Update models as needed
3. Create new views and URL patterns
4. Create or update templates
5. Add any JavaScript functionality
6. Test the feature thoroughly
7. Update documentation

## Deployment

### Production Setup

1. Configure production settings in `settings.py`:
   - Set `DEBUG = False`
   - Set `ALLOWED_HOSTS` appropriately
   - Configure secure cookies and HTTPS
   - Set up production database

2. Collect static files:
   ```bash
   python manage.py collectstatic
   ```

3. Configure a web server (Nginx, Apache) with WSGI (Gunicorn, uWSGI)

4. Set up database backups

5. Configure monitoring and logging

### Continuous Integration/Deployment

The project can be set up with CI/CD using GitHub Actions or similar services:

1. Automated testing on each push
2. Linting and code quality checks
3. Automated deployment to staging/production

---

This documentation provides a comprehensive overview of the Smart Travel Planning and Recommendation System. For specific questions or issues, please contact the project maintainers. 