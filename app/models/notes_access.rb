class NotesAccess < ApplicationRecord
  belongs_to :note
  belongs_to :role
  belongs_to :user
end
