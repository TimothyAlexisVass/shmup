import random
from PIL import Image

# Define image dimensions
width = 1080
height = 7680 // 2

# Create a transparent image
img = Image.new('RGBA', (width, height), (0, 0, 0, 0))  # RGBA for transparency

# Set the chance of a white pixel
white_chance = 0.00005

# Start building the SVG string
svg_content = f'<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">'

# Loop through each pixel
for y in range(height):
  for x in range(width):
    # Randomly decide if a circle is drawn
    if random.random() < white_chance:
      # Generate random radius between 1 and 3
      radius = round(random.uniform(0.1, 2), 1)
      # Add circle element to SVG string with random position and white fill
      svg_content += f'<circle cx="{x + radius}" cy="{y + radius}" r="{radius}" fill="white"/>'

# Close the SVG tag
svg_content += '</svg>'

# Save the SVG content to a file
with open("random_circles_front.svg", "w") as f:
  f.write(svg_content)

print("SVG generated successfully!")