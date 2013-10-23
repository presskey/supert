require 'spec_helper'

describe Search do
  let (:search) { Search.new(query) }

  describe "#perform" do
    subject { search.perform }

    context "when query is a ticket reference" do
      before do
        @ticket1 = FactoryGirl.create(:ticket)
        @ticket2 = FactoryGirl.create(:ticket)
        @ticket3 = FactoryGirl.create(:ticket)
      end
      let (:query) { @ticket2.reference }
      it "returns ticket" do
        expect(subject).to eq(@ticket2)
      end
    end

    context "when query is a text" do
      let (:query) { "word1 word2" }
      let (:results) { [stub(Ticket), stub(Ticket)] }
      it "performs full text search and returns results" do
        Ticket.stub(:search) { results }
        expect(subject).to eq(results)
      end
    end
  end

  describe "#single_result?" do 
    let (:query) { "no matter" }
    subject { search.single_result? }
    context "when result is a single ticket" do
      before { search.results = FactoryGirl.build(:ticket) }
      it { should be_true }
    end
    context "when result is a single ticket inside array" do
      before { search.results = [FactoryGirl.build(:ticket)] }
      it { should be_true }
    end
    context "when result is a set of tickets" do
      before { search.results = FactoryGirl.build_list(:ticket, 3) }
      it { should be_false }
    end
  end
end
