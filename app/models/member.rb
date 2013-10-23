class Member < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :rememberable

  attr_accessible :username, :password, :password_confirmation, :remember_me

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def to_s
    self.username
  end
  
end
