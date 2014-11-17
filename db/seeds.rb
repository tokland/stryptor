module StryptorSeed
  def self.import_images(images_directory)
    Dir.glob(images_directory).sort.each_with_index do |image_path, index|
      image_filename = File.basename(image_path)
      volume, number = image_filename.match(/mafalda-(\d+)_(\d+)/).captures
      code = volume + "-" + number
      #attributes = {code: code, position: index, image: open(image_path)} 
      attributes = {code: code, position: index}
      $stderr.puts("Strip: #{attributes}")
      strip = Strip.where(code: code).first || Strip.new
      strip.update_attributes!(attributes)
    end
  end
end

StryptorSeed.import_images("images/*.jpg")
