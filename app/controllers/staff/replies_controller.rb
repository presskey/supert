class Staff::RepliesController < Staff::BaseController

  before_filter :load_ticket
  respond_to    :html

  def create
    @reply = Reply.new(params[:reply])
    @reply.ticket = @ticket
    @reply.author = current_member
    flash[:notice] = t('replies.created') if @reply.save

    respond_with [:staff, @ticket]
  end

  def load_ticket
    @ticket ||= Ticket.find_by_reference(params[:ticket_id])
  end

end
