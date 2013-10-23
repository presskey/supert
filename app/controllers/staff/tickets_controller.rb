class Staff::TicketsController < Staff::BaseController

  before_filter :load_ticket
  respond_to    :html

  %w/unassigned open onhold closed/.each do |action|
    define_method action do
      @filter  = action
      @tickets = Ticket.send(@filter)

      respond_with @tickets do |format|
        format.html { render 'list' }
      end
    end
  end

  def take_ownership
    @ticket.assignee = current_member
    flash[:notice] = t('tickets.took_ownership', reference: @ticket.reference) if @ticket.save
    
    respond_with @ticket do |format|
      format.html { redirect_to :back }
    end
  end

  def search
    @filter  = :search
    @search  = Search.new(params[:search][:query])
    @tickets = @search.perform

    redirect_to [:staff, @tickets] and return if @search.single_result?

    respond_with @tickets do |format|
      format.html { render 'list' }
    end
  end

  def load_ticket
    @ticket ||= Ticket.find_by_reference(params[:id])
  end

end
