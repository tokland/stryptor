class AddIconToStripCollections < ActiveRecord::Migration
  def change
    change_table :strip_collections do |t|
      t.has_attached_file :image
    end    
  end
  
  def data
    collection = StripCollection.find_by_code("mafalda")
    if collection
      path = "app/assets/images/favicon.gif"
      collection.update_attributes!(:image => open(Rails.root.join(path)))
    end
  end
end
