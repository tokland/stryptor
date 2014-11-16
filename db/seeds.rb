Dir.glob("images/*.jpg").sort.each_with_index do |image_path, index|
  image_filename = File.basename(image_path)
  volume, number = image_filename.match(/mafalda-(\d+)_(\d+)/).captures
  code = volume + "-" + number
  attributes = {code: code, position: index, image: open(image_path)} 
  $stderr.puts("Strip: #{attributes}")
  strip = Strip.where(code: code).first || Strip.new
  strip.update_attributes!(attributes)
end
