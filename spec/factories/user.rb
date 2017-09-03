FactoryGirl.define do
  sequence :user_name do |n|
    "User #{n}"
  end

  sequence :fbid do |n|
    "fbid-#{n}"
  end

  sequence :avatar_url do |n|
    "https://example.com/avatar-#{n}"
  end

  factory :user do
    name { generate(:user_name) }
    fbid
    avatar_url
  end
end
