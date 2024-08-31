class User < ApplicationRecord
  has_secure_password
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  has_many :events
  before_save :downcase_email

   def downcase_email
      self.name.downcase! if self.name
   end
end
