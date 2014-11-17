class Initial < ActiveRecord::Migration
  def change
    create_table :transcripts do |t|
      t.references :strip, index: true
      t.references :user, index: true
      t.text :text
      t.timestamps index: true
    end  

    create_table :strips do |t|
      t.integer :position, index: true
      t.attachment :image
      t.string :code, index: true
      t.date :publised_on
      t.timestamps
    end

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :provider
      t.string :uid
    end
  end
end
