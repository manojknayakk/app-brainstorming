class CreateNotesAccesses < ActiveRecord::Migration[6.0]
  def change
    create_table :notes_accesses do |t|
      t.references :note, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
