class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :customs_code, null:false
      t.integer :total_convert, null: false, default: 0

      t.timestamps
    end
  end
end
