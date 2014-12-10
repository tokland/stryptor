class AddCharactersToStripCollections < ActiveRecord::Migration
  def change
    add_column :strip_collections, :characters, :text
  end
end
