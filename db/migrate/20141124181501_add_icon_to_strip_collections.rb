class AddIconToStripCollections < ActiveRecord::Migration
  def change
    add_column :strip_collections, :icon_url, :string
  end
  
  def data
    collection = StripCollection.find_by_code("mafalda")
    if collection
      url = "http://download.zaudera.com/public/mafalda.gif"
      collection.update_attributes!(:icon_url => url)
    end
  end
end
