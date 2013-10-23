class Department < ActiveRecord::Base

  attr_accessible :name
  
  validates :name, presence: true
  
  def to_s
    self.name
  end

end
