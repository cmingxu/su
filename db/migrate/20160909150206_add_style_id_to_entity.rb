class AddStyleIdToEntity < ActiveRecord::Migration[5.0]
  def change
    add_column :entities, :style_id, :integer
  end
end
