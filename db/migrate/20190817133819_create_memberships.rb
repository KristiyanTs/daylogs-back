class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.references :user, foreign_key: true
      t.references :node, foreign_key: true
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
