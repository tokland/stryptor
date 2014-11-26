class CreateStripCollections < ActiveRecord::Migration
  def change
    create_table :strip_collections do |t|
      t.string :code
      t.string :name
      t.text :description

      t.timestamps
    end
    
    add_column :strips, :strip_collection_id, :integer, references: :strip_collections
  end
end
