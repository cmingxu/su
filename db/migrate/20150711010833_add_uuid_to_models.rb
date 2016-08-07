class AddUuidToModels < ActiveRecord::Migration
  def change
    add_column :users, :uuid, :string
    add_column :folders, :uuid, :string
    add_column :entities, :uuid, :string
    add_column :materials, :uuid, :string
    add_column :vendors, :uuid, :string
  end
end
