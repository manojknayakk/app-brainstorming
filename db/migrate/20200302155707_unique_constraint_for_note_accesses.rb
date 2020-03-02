class UniqueConstraintForNoteAccesses < ActiveRecord::Migration[6.0]
  def change
    add_index :notes_accesses, [:user_id, :note_id], :unique => true
  end
end
