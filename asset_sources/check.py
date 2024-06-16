import os

def check_missing_base_images():
    current_folder = os.getcwd()
    xcf_files = [f for f in os.listdir(current_folder) if f.endswith('.xcf')]
    
    missing_base_images = []
    
    for xcf_file in xcf_files:
        base_image = os.path.join(current_folder, 'ready_for_generation', f"{os.path.splitext(xcf_file)[0]}-base.png")
        if not os.path.exists(base_image):
            missing_base_images.append(xcf_file)
    
    return missing_base_images

if __name__ == "__main__":
    missing_files = check_missing_base_images()
    if missing_files:
        print("The following .xcf files are missing corresponding base images:")
        for file in missing_files:
            print(file)
    else:
        print("All .xcf files have corresponding base images.")
