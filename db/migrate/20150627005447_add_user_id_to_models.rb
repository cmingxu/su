class AddUserIdToModels < ActiveRecord::Migration
  def change
    add_column :folders, :user_id, :integer
    add_column :entities, :user_id, :integer
  end
end
