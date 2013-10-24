require 'spec_helper'

describe TicketsController do

  let (:ticket) { FactoryGirl.create(:ticket) } 

  describe "GET new" do
    before { get :new }
    it "assigns a new Ticket to @ticket" do
      expect(assigns(:ticket)).to be_a_new Ticket
    end
    it "renders the :new template" do
      expect(response).to render_template :new
    end
  end

  describe "GET show" do
    before { get :show, id: ticket }
    it "assigns the requested ticket to @ticket" do
      expect(assigns(:ticket)).to eq ticket
    end
    it "renders the :show template" do
      expect(response).to render_template :show
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates new ticket" do
        expect{ post :create, ticket: FactoryGirl.attributes_for(:ticket) }.to change{Ticket.count}.by(1)
      end
      it "renders the :create template" do
        post :create, ticket: FactoryGirl.attributes_for(:ticket)
        expect(response).to render_template :create
      end
    end

    context "with invalid attributes" do
      it "doesn't create new ticket" do
        expect{ post :create, ticket: FactoryGirl.attributes_for(:ticket, :invalid) }.to_not change{Ticket.count}.by(1)
      end
      it "re-renders the :new template" do
        post :create, ticket: FactoryGirl.attributes_for(:ticket, :invalid)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT update' do 
    before { @ticket = FactoryGirl.create(:ticket) }

    context "valid attributes" do
      let (:client_name) { 'Alex' }
      let (:client_email) { 'new@email.com' }
      before { put :update, id: @ticket, ticket: FactoryGirl.attributes_for(:ticket, client_name: client_name, client_email: client_email) }

      it "assigns the requested ticket to @ticket" do 
        assigns(:ticket).should eq(@ticket) 
      end 

      it "changes @ticket" do
        @ticket.reload
        @ticket.client_name.should eq(client_name) 
        @ticket.client_email.should eq(client_email) 
      end 

      it "assigns flash notice" do
        flash[:notice].should be_present
      end

      it "redirects to the updated ticket" do
        response.should redirect_to @ticket 
      end 
    end 

    context "invalid attributes" do
      it "doesn't assign flash notice" do
        flash[:notice].should_not be_present
      end

      it "redirects to the ticket" do 
        put :update, id: @ticket, ticket: FactoryGirl.attributes_for(:ticket, :invalid)
        response.should redirect_to @ticket 
      end 
    end 
  end

end
