from django.utils import timezone
from django.contrib.auth.models import User

class UserActivityMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        
        # Update last activity time for authenticated users
        if request.user.is_authenticated:
            # Update the user's last activity timestamp
            try:
                profile = request.user.userprofile
                profile.last_activity = timezone.now()
                profile.save(update_fields=['last_activity'])
            except Exception:
                # If user profile doesn't exist or can't be updated, just continue
                pass

        return response 