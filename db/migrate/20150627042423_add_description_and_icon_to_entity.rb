class AddDescriptionAndIconToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :description, :text
    add_column :entities, :icon, :string
  end
end
