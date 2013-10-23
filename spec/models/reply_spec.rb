require 'spec_helper'

describe Reply do
  [:response, :new_assignee_id, :new_status_id].each do |attribute|
    it { should allow_mass_assignment_of(attribute) }
  end

  it { should validate_presence_of :response}

  it { should belong_to :ticket }
  it { should belong_to :author }
  it { should belong_to :new_assignee }

  describe "#new_status" do 
    subject { FactoryGirl.build(:reply, new_status_id: 0) }
    it "is a symbol" do 
      expect(subject.new_status).to be_a(Symbol)
    end 

    it "is corresponds to new_status_id" do
      expect(Ticket::STATUS[subject.new_status]).to eq(subject.new_status_id)
    end
  end

  context "when created" do
    subject { FactoryGirl.create(:reply) }
    let (:ticket) { subject.ticket }
    let (:status) { :on_hold }
    it "sends notification to customer" do
      expect { subject.run_callbacks(:commit) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    context "when new_status set" do
      before { subject.new_status_id = Ticket::STATUS[status] }
      it "changes ticket status" do
        expect { subject.run_callbacks(:commit) }.to change { ticket.status }.to(status)
      end
    end

    context "when new_assignee set" do
      let (:assignee) { FactoryGirl.create(:member) }
      before { subject.new_assignee_id = assignee.id }
      it "changes ticket assignee" do
        expect { subject.run_callbacks(:commit) }.to change { ticket.assignee }.to(assignee)
      end
    end

    it "updates associated ticket" do
      subject.ticket.should_receive(:save)
      subject.run_callbacks(:commit)
    end
  end
end
