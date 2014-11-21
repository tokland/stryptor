class AddInfoToStripCollections < ActiveRecord::Migration
  def change
    add_column :strip_collections, :footer, :text
    add_column :strip_collections, :image_url, :string
  end
  
  def data
    collection = StripCollection.find_by!(code: "mafalda")
    collection.update_attributes!(
      :image_url => "http://mafalda.zaudera.com/images/mafalda-%{code}.jpg",
      :footer => %q{
        <br />&#169; Quino |
        <a href="http://en.wikipedia.org/wiki/Mafalda">Wikipedia</a> |
        <a href="https://www.google.es/search?q=comprar+mafalda">Comprar</a>
      }
    )
  end
end
