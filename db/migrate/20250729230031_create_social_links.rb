class CreateSocialLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :social_links, id: :uuid do |t|
      t.references :site, null: false, foreign_key: true, type: :uuid
      t.string :platform
      t.string :url
      t.integer :position

      t.timestamps
    end
  end
end
