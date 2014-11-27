module StryptorSeed
  def self.create_strips(images)
    collection = StripCollection.create!({
      :name => "Mafalda", 
      :code => "mafalda",
      :icon_url => "http://download.zaudera.com/public/mafalda.gif",
      :image_url => "http://mafalda.zaudera.com/images/mafalda-%{code}.jpg",
      :footer => %q{
        <br />&#169; Quino |
        <a href="http://en.wikipedia.org/wiki/Mafalda">Wikipedia</a> |
        <a href="https://www.google.es/search?q=comprar+mafalda">Comprar</a>
      },
    })
    
    images.sort.each_with_index do |image_path, index|
      image_filename = File.basename(image_path)
      volume, number = image_filename.match(/mafalda-(\d+)-(\d+)/).captures
      code = volume + "-" + number
      attributes = {code: code, position: index, strip_collection: collection}
      $stderr.puts("Strip: #{attributes}")
      strip = Strip.where(code: code).first || Strip.new
      strip.update_attributes!(attributes)
    end
  end
end

StryptorSeed.create_strips(Dir.glob("images/*.jpg"))
