class AddIsSystemToFoldersAndEntities < ActiveRecord::Migration
  def change
    add_column :entities, :is_system, :boolean, default: false
  end
end
