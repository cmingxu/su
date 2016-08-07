class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :tel
      t.string :address
      t.text :short_desc
      t.text :desc

      t.timestamps null: false
    end
  end
end
