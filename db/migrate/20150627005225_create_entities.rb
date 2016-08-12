class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.integer :category_id
      t.string :name
      t.string :skp_file

      t.timestamps null: false
    end
  end
end
