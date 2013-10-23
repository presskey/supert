class Ticket < ActiveRecord::Base

  STATUS = {
    :waiting_for_staff_response   => 0,
    :waiting_for_customer         => 1,
    :on_hold                      => 2,
    :cancelled                    => 3,
    :completed                    => 4
  }

  REFERENCE_REGEXP = /\A[A-Z]{3}-[0-9]{6}\z/

  attr_accessible :client_name, :client_email, :department_id, :subject, :body, :status

  belongs_to :department
  belongs_to :assignee, class_name: 'Member'
  has_many   :replies

  validates :client_name,  presence: true
  validates :client_email, presence: true, format: /@/
  validates :subject,      presence: true
  validates :body,         presence: true

  scope :unassigned, -> { where(assignee_id: nil).order('created_at DESC') }
  scope :open,       -> { where("status_id NOT IN (?)", [ STATUS[:cancelled], STATUS[:completed] ]) }
  scope :onhold,     -> { where(status_id: STATUS[:on_hold]) }
  scope :closed,     -> { where(status_id: [ STATUS[:cancelled], STATUS[:completed] ]) }

  define_index do 
    indexes subject, body
  end

  before_create :generate_reference
  after_commit  :send_notification,  on: :create
  before_save   :set_default_status

  def to_param
    self.reference
  end

  def status
    STATUS.invert[status_id]
  end

  def status=(value)
    self.status_id = STATUS[value]
  end

  def generate_reference
    self.reference = loop do
      random_reference = [*('A'..'Z')].sample(3).join + '-' + [*('0'..'9')].sample(6).join
      break random_reference unless Ticket.exists?(reference: random_reference)
    end
  end

  def set_default_status
    self.status = :waiting_for_staff_response unless self.status_id_changed?
  end

  def send_notification
    TicketNotifications.posted(self).deliver
  end
end
