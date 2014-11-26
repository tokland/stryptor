class AddIconToStripCollections < ActiveRecord::Migration
  def change
    add_column :strip_collections, :icon_url, :string
  end
end
