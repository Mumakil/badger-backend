FactoryGirl.define do
  sequence :group_name do |n|
    "Group #{n}"
  end

  sequence :photo_url do |n|
    "https://example.com/avatar-#{n}"
  end

  factory :group do
    name { generate(:group_name) }
    photo_url
    creator { create(:user) }
  end
end
