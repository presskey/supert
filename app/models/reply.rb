class Reply < ActiveRecord::Base
  attr_accessible :response, :new_assignee_id, :new_status_id

  belongs_to :ticket
  belongs_to :author,       class_name: 'Member'
  belongs_to :new_assignee, class_name: 'Member'

  validates :response, presence: true

  after_commit  :update_ticket,     on: :create
  after_commit  :send_notification, on: :create

  def new_status
    Ticket::STATUS.invert[new_status_id]
  end

  def update_ticket
    ticket.status   = new_status   if new_status.present?
    ticket.assignee = new_assignee if new_assignee.present?
    ticket.save
  end

  def send_notification
    TicketNotifications.replied(self).deliver
  end
end
