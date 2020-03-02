class NotesAccess < ApplicationRecord
  belongs_to :note
  belongs_to :role
  belongs_to :user
  validates_uniqueness_of :user_id, scope: %i[note_id]
end
