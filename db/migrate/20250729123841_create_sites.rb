class CreateSites < ActiveRecord::Migration[8.0]
  def change
    create_table :sites, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.string :slug, null: false
      t.boolean :published, default: false
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :sites, [:user_id, :slug], unique: true
  end
end
