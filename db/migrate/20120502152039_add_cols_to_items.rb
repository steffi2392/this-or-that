class AddColsToItems < ActiveRecord::Migration
  def change
  	remove_column :items, :image
  	remove_column :items, :name
  	add_column :items, :image_front, :string
    add_column :items, :image_back, :string
    add_column :items, :link, :string
  end
end
