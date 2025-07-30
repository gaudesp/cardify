class CreateSites < ActiveRecord::Migration[8.0]
  def change
    create_table :sites, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :company_name, null: false
      t.string :slug, null: false
      t.string :phone_number
      t.string :contact_email
      t.boolean :published, default: false
      t.jsonb :setting, default: {
        theme: {
          color_primary: '#86d17c',
          color_secondary: '#50a2a1',
          background_gradient: 'bottom right',
          radius: '10px'
        }
      }

      t.timestamps
    end

    add_index :sites, [:user_id, :slug], unique: true
  end
end
