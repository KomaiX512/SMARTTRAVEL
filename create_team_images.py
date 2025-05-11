from PIL import Image, ImageDraw, ImageFont
import os

# Create directory if it doesn't exist
os.makedirs('travel_planner/static/img/team', exist_ok=True)

# Team members data
team_members = [
    {'name': 'Mahreen', 'title': 'CEO', 'filename': 'ceo.jpg', 'color': (70, 130, 180)},  # Steel Blue
    {'name': 'Javid', 'title': 'CTO', 'filename': 'cto.jpg', 'color': (46, 139, 87)},  # Sea Green
    {'name': 'Fatima', 'title': 'Head of Customer Experience', 'filename': 'customer-experience.jpg', 'color': (221, 160, 221)},  # Plum
    {'name': 'Kamran', 'title': 'Chief Travel Officer', 'filename': 'travel-officer.jpg', 'color': (210, 105, 30)},  # Chocolate
]

# Create professional-looking placeholder images
for member in team_members:
    # Create a 600x800 image with the member's color
    img = Image.new('RGB', (600, 800), member['color'])
    draw = ImageDraw.Draw(img)
    
    try:
        # Try to use a system font
        font_large = ImageFont.truetype('Arial', 60)
        font_small = ImageFont.truetype('Arial', 40)
    except IOError:
        # Fallback to default font
        font_large = ImageFont.load_default()
        font_small = ImageFont.load_default()
    
    # Draw text in the center
    name_text = member['name']
    title_text = member['title']
    
    # Calculate positions (centered)
    w, h = draw.textsize(name_text, font=font_large) if hasattr(draw, 'textsize') else (300, 60)
    x = (600 - w) // 2
    y = 350  # Position for name
    
    # Draw with a shadow effect for better visibility
    draw.text((x+2, y+2), name_text, fill=(0, 0, 0, 128), font=font_large)
    draw.text((x, y), name_text, fill=(255, 255, 255), font=font_large)
    
    # Draw title
    w, h = draw.textsize(title_text, font=font_small) if hasattr(draw, 'textsize') else (300, 40)
    x = (600 - w) // 2
    y = 430  # Position for title
    
    draw.text((x+2, y+2), title_text, fill=(0, 0, 0, 128), font=font_small)
    draw.text((x, y), title_text, fill=(255, 255, 255), font=font_small)
    
    # Save image
    img.save(f"travel_planner/static/img/team/{member['filename']}")
    
    print(f"Created image for {member['name']} ({member['title']})")

print("All team member images have been created successfully!") 