class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages, id: :uuid do |t|
      t.references :site, null: false, foreign_key: true, type: :uuid
      t.string :tab, null: false
      t.string :slug, null: false
      t.string :icon, null: false
      t.integer :position

      t.timestamps
    end

    add_index :pages, [:site_id, :slug], unique: true
  end
end
