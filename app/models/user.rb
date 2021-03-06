class User < ApplicationRecord
  has_many :notes_accesses
  has_many :notes, :through => :notes_accesses
  has_many :roles, :through => :notes_accesses
  
  validates_presence_of :first_name, :last_name, :email, :password, :password_confirmation
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_uniqueness_of :email, :case_sensitive => false
  validates :password, confirmation: true
  validates :password, length: { in: 6..20 }
  before_save { self.email = self.email.downcase }

  has_secure_password

end
