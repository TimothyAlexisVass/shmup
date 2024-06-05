require 'mini_magick'
require 'fileutils'

def resize_images_in_subfolders(base_folder)
  Dir.glob("#{base_folder}/**/*.png").each do |file_path|
    image = MiniMagick::Image.open(file_path)
    new_width = (image.width / 4.0).round
    new_height = (image.height / 4.0).round

    image.resize "#{new_width}x#{new_height}"
    image.write file_path
    puts "Resized and saved image: #{file_path}"
  end
end

if __FILE__ == $0
  script_folder = File.expand_path(File.dirname(__FILE__))
  resize_images_in_subfolders(script_folder)
end
