#!/bin/bash

# Change to the project directory
cd "$(dirname "$0")"

echo "Stopping hosting services..."

# Kill processes from the PID file if it exists
if [ -f "hosting_pids.txt" ]; then
    kill $(cat hosting_pids.txt) 2>/dev/null || echo "Processes from PID file already stopped"
    rm hosting_pids.txt
fi

# Find and kill any remaining ngrok processes
NGROK_PIDS=$(pgrep -f "ngrok http")
if [ -n "$NGROK_PIDS" ]; then
    echo "Stopping ngrok processes: $NGROK_PIDS"
    kill $NGROK_PIDS 2>/dev/null || echo "Failed to stop some ngrok processes"
fi

# Find and kill any Django runserver processes
DJANGO_PIDS=$(pgrep -f "python manage.py runserver")
if [ -n "$DJANGO_PIDS" ]; then
    echo "Stopping Django processes: $DJANGO_PIDS"
    kill $DJANGO_PIDS 2>/dev/null || echo "Failed to stop some Django processes"
fi

echo "All hosting services stopped successfully" 