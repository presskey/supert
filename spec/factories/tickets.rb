# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket do
    client_name   'Alex'
    client_email  'no@no.no'
    subject       'subject'
    body          'message'

    trait :unassigned do
      assignee nil
    end
    
    trait :assigned do
      association :assignee, factory: :member
    end

    [:waiting_for_staff_response, :waiting_for_customer, :on_hold, :cancelled, :completed].each do |status|
      trait status do
        status status
      end
    end

    trait :invalid do
      client_email "invalid"
    end
  end
end
