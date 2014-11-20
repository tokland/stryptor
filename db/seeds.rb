module StryptorSeed
  def self.import_images(images)
    collection = StripCollection.create!(:name => "Mafalda", :code => "mafalda")
    
    images.sort.each_with_index do |image_path, index|
      image_filename = File.basename(image_path)
      volume, number = image_filename.match(/mafalda-(\d+)_(\d+)/).captures
      code = volume + "-" + number
      #attributes = {code: code, position: index, image: open(image_path)} 
      attributes = {code: code, position: index, collection: collection}
      $stderr.puts("Strip: #{attributes}")
      strip = Strip.where(code: code).first || Strip.new
      strip.update_attributes!(attributes)
    end
  end
end

StryptorSeed.import_images(Dir.glob("images/*.jpg")))
