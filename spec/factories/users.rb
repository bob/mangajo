FactoryGirl.define do

  factory :user do
    after(:build) { |user| user.class.set_callback(:create, :after, :add_rations) }
    before(:create) { |user| create(:ration_user, :id => 1) unless Ration.find_by_id(1) }

    sequence(:email) { |n| "test#{n}@example.com" }
    password 'password'
  end

  factory :user_simple, :class => User do
    after(:build) { |user| user.class.skip_callback(:create, :after, :add_rations) }

    sequence(:email) { |n| "test_2#{n}@example.com" }
    password 'password'
  end

end
