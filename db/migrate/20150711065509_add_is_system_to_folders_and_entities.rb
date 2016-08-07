class AddIsSystemToFoldersAndEntities < ActiveRecord::Migration
  def change
    add_column :folders, :is_system, :boolean, default: false
    add_column :entities, :is_system, :boolean, default: false
  end
end
