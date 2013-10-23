require 'spec_helper'

describe Department do
  
  subject { FactoryGirl.create(:department) }

  it { should validate_presence_of :name }
  it { should allow_mass_assignment_of(:name) }

  it 'returns name when used as string' do
    expect("#{subject}").to eq(subject.name)
  end
end
