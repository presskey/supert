# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    sequence(:username) {|n| "username_#{n}" }
  end
end
