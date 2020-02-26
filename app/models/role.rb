class Role < ApplicationRecord
    has_many :notes_accesses
    has_many :users, :through => :notes_accesses
end
