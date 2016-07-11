class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.string :name
      t.string :os
      t.timestamp :leased_at
      t.string :leased_until
      t.references :user, foreign_key: true, null: true

      t.timestamps
    end
  end
end
