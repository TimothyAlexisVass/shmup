import os

# Path to the main folder containing subfolders
main_folder = 'ships'

# HTML header and styles
html_content = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Image Gallery</title>
    <style>
        body {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            padding: 10px;
            font-family: Arial, sans-serif;
        }
        .image-container {
            text-align: center;
        }
        .image-container img {
            width: 128px;
            display: block;
            margin: 0 auto;
        }
        .image-container p {
            margin: 5px 0 0;
        }
    </style>
</head>
<body>
'''

# Traverse the directory structure
for subdir, dirs, files in os.walk(main_folder):
    # Sort the directories and files to ensure alphabetical order
    dirs.sort()
    for file in files:
        if file.endswith('_0.png'):
            # Get the relative path to the image
            relative_path = os.path.relpath(os.path.join(subdir, file), main_folder)
            folder_name = os.path.basename(subdir)
            # Add the image to the HTML content
            html_content += f'''
            <div class="image-container">
                <img src="{main_folder}/{relative_path}" alt="{folder_name}">
                <p>{folder_name}</p>
            </div>
            '''

# HTML footer
html_content += '''
</body>
</html>
'''

# Write the HTML content to a file
output_file = 'gallery.html'
with open(output_file, 'w') as f:
    f.write(html_content)

print(f'HTML gallery created: {output_file}')