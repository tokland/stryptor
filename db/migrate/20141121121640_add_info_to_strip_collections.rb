class AddInfoToStripCollections < ActiveRecord::Migration
  def change
    add_column :strip_collections, :footer, :text
    add_column :strip_collections, :image_url, :string
  end
end
