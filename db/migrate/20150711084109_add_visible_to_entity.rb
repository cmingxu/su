class AddVisibleToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :visible, :boolean, default: true
  end
end
