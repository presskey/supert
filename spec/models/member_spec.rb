require 'spec_helper'

describe Member do
    
  subject { FactoryGirl.create(:member) }

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username).case_insensitive }

  [:username, :password, :password_confirmation, :remember_me].each do |attribute|
    it { should allow_mass_assignment_of(attribute) }
  end

  it 'is database authenticatable' do
    expect(subject.class.ancestors).to include(::Devise::Models::DatabaseAuthenticatable)
  end

  it 'is registerable' do
    expect(subject.class.ancestors).to include(::Devise::Models::Registerable)
  end

  it 'is rememberable' do
    expect(subject.class.ancestors).to include(::Devise::Models::Rememberable)
  end

  it 'returns username when used as string' do
    expect("#{subject}").to eq(subject.username)
  end
end
