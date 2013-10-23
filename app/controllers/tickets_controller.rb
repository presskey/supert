class TicketsController < ApplicationController

  before_filter :load_ticket
  respond_to    :html

  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.save
    respond_with @ticket
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
