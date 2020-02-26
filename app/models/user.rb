class User < ApplicationRecord
  has_many :notes_accesses
  has_many :notes, :through => :notes_accesses
  has_many :roles, :through => :notes_accesses
  has_secure_password
end
