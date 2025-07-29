class CreateSites < ActiveRecord::Migration[8.0]
  def change
    create_table :sites, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :company_name, null: false
      t.string :slug, null: false
      t.string :phone_number
      t.string :contact_email
      t.boolean :published, default: false
      t.jsonb :setting, default: {}

      t.timestamps
    end

    add_index :sites, [:user_id, :slug], unique: true
  end
end
