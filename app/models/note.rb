class Note < ApplicationRecord
    has_many :notes_accesses,  dependent: :destroy 
    has_many :users, :through => :notes_accesses
    accepts_nested_attributes_for :notes_accesses, reject_if: :all_blank, allow_destroy: true
end
