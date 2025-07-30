class CreateCardMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :card_menu_items, id: :uuid do |t|
      t.references :card_menu_category, type: :uuid, null: false, foreign_key: true
      t.string :title, null: false
      t.string :subtitle
      t.text :ingredients
      t.decimal :price, precision: 8, scale: 2
      t.integer :position

      t.timestamps
    end

    add_index :card_menu_items, [:card_menu_category_id, :position]
  end
end
