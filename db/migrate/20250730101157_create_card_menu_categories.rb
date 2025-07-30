class CreateCardMenuCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :card_menu_categories, id: :uuid do |t|
      t.references :card_menu, type: :uuid, null: false, foreign_key: { to_table: :cards }
      t.string :title, null: false
      t.string :subtitle
      t.integer :position

      t.timestamps
    end

    add_index :card_menu_categories, [:card_menu_id, :position]
  end
end
