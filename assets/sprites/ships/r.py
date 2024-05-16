import os

def find_folders_without_crystal_png(root_folder):
    folders_without_crystal_png = []
    for root, dirs, files in os.walk(root_folder):
        if any('_crystal.png' in filename for filename in files):
            continue
        folders_without_crystal_png.append(root)
    return folders_without_crystal_png

if __name__ == "__main__":
    root_folder = os.path.dirname(os.path.abspath(__file__))
    folders_without_crystal_png = find_folders_without_crystal_png(root_folder)
    if folders_without_crystal_png:
        print("Folders without _crystal.png file:")
        for folder in folders_without_crystal_png:
            print(folder)
    else:
        print("All folders contain _crystal.png file.")
