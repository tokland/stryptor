class AddTextToStrips < ActiveRecord::Migration
  def change
    add_column :strips, :text, :text
  end
end
