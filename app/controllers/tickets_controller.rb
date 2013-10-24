class TicketsController < ApplicationController

  before_filter :load_ticket
  respond_to    :html

  def create
    @ticket = Ticket.new(params[:ticket])
    respond_with @ticket do |format|
      if @ticket.save
        format.html { render }
      else
        format.html { render :new }
      end
    end
  end

  def new
    @ticket = Ticket.new
    respond_with @ticket
  end

  def update
    flash[:notice] = t('tickets.updated') if @ticket.update_attributes(params[:ticket])  

    respond_with(@product, :location => [@ticket])   
  end

  def load_ticket
    @ticket ||= Ticket.find_by_reference(params[:id])
  end

end
