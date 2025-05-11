#!/bin/bash

# Change to the project directory
cd "$(dirname "$0")"

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Check for existing ngrok and Django processes
EXISTING_NGROK=$(pgrep -f "ngrok http")
EXISTING_DJANGO=$(pgrep -f "python manage.py runserver")

if [ -n "$EXISTING_NGROK" ]; then
    echo "Ngrok is already running with PID: $EXISTING_NGROK"
    echo "Getting the existing URL..."
    PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | grep -o 'http[^"]*')
    
    if [ -n "$PUBLIC_URL" ]; then
        echo "==============================================="
        echo "Your website is already accessible at: $PUBLIC_URL"
        echo "==============================================="
        echo "To use a new URL, first stop the current session with: ./stop_hosting.sh"
        exit 0
    else
        echo "Could not get the existing URL. Stopping existing sessions..."
        ./stop_hosting.sh
    fi
fi

# Start Django server in the background
echo "Starting Django server..."
python manage.py runserver 0.0.0.0:8000 > django_server.log 2>&1 &
DJANGO_PID=$!
echo "Django server started with PID: $DJANGO_PID"

# Wait for server to start
sleep 3

# Start ngrok in the background
echo "Starting ngrok..."
ngrok http 8000 > /dev/null 2>&1 &
NGROK_PID=$!
echo "Ngrok started with PID: $NGROK_PID"

# Wait for ngrok to initialize (increased wait time)
echo "Waiting for ngrok to initialize..."
sleep 8

# Get the public URL
echo "Getting ngrok URL..."
PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | grep -o 'http[^"]*')

if [ -n "$PUBLIC_URL" ]; then
    echo "==============================================="
    echo "Your website is now accessible at: $PUBLIC_URL"
    echo "==============================================="
    echo "To stop the server, run: ./stop_hosting.sh"
else
    echo "Failed to get ngrok URL. Check if ngrok is running properly."
    echo "You can manually check the URL at http://localhost:4040"
    echo "If you're seeing an authentication error, make sure no other ngrok sessions are running."
    echo "Run './stop_hosting.sh' and try again."
fi

# Save the PIDs for later use
echo "$DJANGO_PID $NGROK_PID" > hosting_pids.txt

echo "Server and ngrok are running in the background."
echo "Use './stop_hosting.sh' to stop them." 