class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards, id: :uuid do |t|
      t.references :page, null: false, foreign_key: true, type: :uuid
      t.string :type, null: false
      t.integer :position
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :cards, [:page_id, :position]
  end
end
