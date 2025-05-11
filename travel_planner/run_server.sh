#!/bin/bash

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Collect static files
python manage.py collectstatic --noinput

# Run with Gunicorn on port 8000
gunicorn travel_planner.wsgi:application --bind 0.0.0.0:8000 