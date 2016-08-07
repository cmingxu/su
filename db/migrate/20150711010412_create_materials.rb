class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :name
      t.integer :vendor_id
      t.string :icon
      t.decimal :price

      t.timestamps null: false
    end
  end
end
