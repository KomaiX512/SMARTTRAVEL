from django.shortcuts import render, redirect
from django.contrib import messages
from django.core.mail import send_mail
from django.conf import settings
from django.contrib.auth.decorators import user_passes_test
from django.apps import apps
from django.db.models import Count

def redirect_to_login(request):
    return redirect('users:login')

def redirect_to_register(request):
    return redirect('users:register')

def redirect_to_logout(request):
    return redirect('users:logout')

def contact_view(request):
    if request.method == 'POST':
        name = request.POST.get('name', '')
        email = request.POST.get('email', '')
        subject = request.POST.get('subject', '')
        message = request.POST.get('message', '')
        
        # Form validation
        if not all([name, email, subject, message]):
            messages.error(request, 'Please fill in all fields.')
            return render(request, 'base/contact.html', {
                'form_data': request.POST
            })
        
        # Construct email message
        email_message = f"Name: {name}\nEmail: {email}\n\n{message}"
        
        try:
            # In production, this would send an actual email
            # For now, we'll simulate success
            
            # send_mail(
            #     f"Contact Form: {subject}",
            #     email_message,
            #     email,
            #     [settings.DEFAULT_FROM_EMAIL],
            #     fail_silently=False,
            # )
            
            messages.success(request, 'Your message has been sent. We will get back to you soon!')
            return redirect('contact')
        except Exception as e:
            messages.error(request, f'An error occurred: {str(e)}')
    
    return render(request, 'base/contact.html')

def is_admin(user):
    return user.is_authenticated and user.is_superuser

@user_passes_test(is_admin)
def admin_dashboard(request):
    """
    Admin dashboard showing database tables and record counts
    """
    # Get all installed models
    app_models = []
    
    for app_config in apps.get_app_configs():
        if app_config.name.startswith('django.') or app_config.name == 'travel_planner':
            continue
            
        app_name = app_config.verbose_name
        models = []
        
        for model in app_config.get_models():
            model_name = model.__name__
            model_count = model.objects.count()
            model_url = f"/admin/{app_config.label}/{model.__name__.lower()}"
            
            models.append({
                'name': model_name,
                'count': model_count,
                'url': model_url
            })
        
        if models:
            app_models.append({
                'name': app_name,
                'models': models
            })
    
    # Get recent activities
    # Import models here to avoid circular imports
    from destinations.models import Destination
    from users.models import UserProfile
    from bookings.models import Trip
    from reviews.models import DestinationReview
    
    context = {
        'app_models': app_models,
        'total_destinations': Destination.objects.count(),
        'total_users': UserProfile.objects.count(),
        'total_trips': Trip.objects.count(),
        'total_reviews': DestinationReview.objects.count(),
    }
    
    return render(request, 'admin/dashboard.html', context) 