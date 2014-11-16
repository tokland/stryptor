class Initial < ActiveRecord::Migration
  def change
    create_table :transcripts do |t|
      t.text :text
      t.timestamps
    end  

    create_table :strips do |t|
      t.integer :position
      t.attachment :image
      t.string :code
      t.date :publised_on
      t.timestamps
    end  
  
    add_index :strips, :code
    add_index :strips, :position
    add_index :transcripts, :created_at
  end
end
