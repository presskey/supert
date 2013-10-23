class TicketNotifications < ActionMailer::Base
  default from: "from@example.com"
  layout 'mail'

  def posted(ticket)
    @ticket = ticket

    mail to: @ticket.client_email, subject: "Your request has been received"
  end

  def replied(reply)
    @reply  = reply
    @ticket = reply.ticket

    mail to: @ticket.client_email, subject: "New reply to your ticket"
  end
end
