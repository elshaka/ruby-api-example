FactoryGirl.define do
  factory :user, class: Api::Models::User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { ('a'..'z').to_a.shuffle.join }
    born_on Date.new(2000, 1, 1)

    trait :empty do
      first_name ""
      last_name ""
      email ""
      password ""
    end
  end
end
