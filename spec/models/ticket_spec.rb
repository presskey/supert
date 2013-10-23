require 'spec_helper'

describe Ticket do

  [:client_name, :client_email, :department_id, :subject, :body, :status].each do |attribute|
    it { should allow_mass_assignment_of(attribute) }
  end

  [:client_name, :client_email, :subject, :body].each do |attribute|
    it { should validate_presence_of(attribute) }
  end

  it { should_not allow_value('bad').for(:client_email) }
  it { should allow_value('bad@email.com').for(:client_email) }

  it { should belong_to :department }
  it { should belong_to :assignee }
  it { should have_many :replies }

  specify "has STATUS map" do
    expect(Ticket.const_defined?(:STATUS)).to be_true
    expect(Ticket::STATUS).to be_a(Hash)
  end

  describe Ticket, ".unassigned" do
    subject { Ticket.unassigned }
    
    it "includes tickets without assignee" do
      ticket = FactoryGirl.create(:ticket, :unassigned)
      expect(subject).to include(ticket)
    end

    it "excludes tickets with assignee" do
      ticket = FactoryGirl.create(:ticket, :assigned)
      expect(subject).to_not include(ticket)
    end

    it "orders tickets by descending date of creation" do
      order1 = FactoryGirl.create(:ticket, :unassigned, created_at: 2.days.ago)
      order2 = FactoryGirl.create(:ticket, :unassigned, created_at: 1.day.ago)
      order3 = FactoryGirl.create(:ticket, :unassigned, created_at: Date.today)
      expect(subject).to eq([order3, order2, order1])
    end
  end

  it "uses reference as id for URLs" do
    expect(subject.to_param).to eq(subject.reference)
  end

  describe "#status" do 
    it "is a symbol" do 
      expect(subject.status).to be_a(Symbol)
    end 

    it "is corresponds to status_id" do
      expect(Ticket::STATUS[subject.status]).to eq(subject.status_id)
    end
  end

  describe "#status=" do
    let(:ticket) { FactoryGirl.create(:ticket) }
    let(:status) { :on_hold }
    it "sets status_id to corresponding value" do
      expect{ticket.status = status}.to change{ticket.status_id}.to(Ticket::STATUS[status])
    end
  end

  context "when created" do
    subject { FactoryGirl.create(:ticket, reference: nil) }
    its (:reference) { should_not be_nil }
    its (:reference) { should match /\A[A-Z]{3}-[0-9]{6}\z/ }
    it "has unique reference" do
      references = FactoryGirl.create_list(:ticket, 5).map(&:reference)
      expect(references).to eq(references.uniq)
    end

    its (:status) { should be :waiting_for_staff_response}

    it "sends notification to customer" do
      expect { subject.run_callbacks(:commit) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe Ticket, ".open" do
    subject { Ticket.open }
    
    it "includes open tickets" do
      tickets = [:waiting_for_staff_response, :waiting_for_customer, :on_hold].map { |status| FactoryGirl.create(:ticket, status) }
      expect(subject).to include(*tickets)
    end

    it "excludes cancelled or completed tickets" do
      cancelled_ticket = FactoryGirl.create(:ticket, :cancelled)
      completed_ticket = FactoryGirl.create(:ticket, :completed)
      expect(subject).to_not include(cancelled_ticket, completed_ticket)
    end
  end

  describe Ticket, ".onhold" do
    subject { Ticket.onhold }
    
    it "includes onhold tickets" do
      ticket = FactoryGirl.create(:ticket, :on_hold)
      expect(subject).to include(ticket)
    end

    it "excludes tickets with other statuses" do
      tickets = [ :waiting_for_staff_response, :waiting_for_customer, :cancelled, :completed ].map { |status| FactoryGirl.create(:ticket, status) }
      expect(subject).to_not include(*tickets)
    end
  end

  describe Ticket, ".closed" do
    subject { Ticket.closed }
    
    it "includes cancelled and completed tickets" do
      cancelled_ticket = FactoryGirl.create(:ticket, :cancelled)
      completed_ticket = FactoryGirl.create(:ticket, :completed)
      expect(subject).to include(cancelled_ticket, completed_ticket)
    end

    it "excludes open tickets" do
      tickets = [ :waiting_for_staff_response, :waiting_for_customer, :on_hold ].map { |status| FactoryGirl.create(:ticket, status) }
      expect(subject).to_not include(*tickets)
    end
  end

end
