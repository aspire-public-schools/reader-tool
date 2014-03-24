FactoryGirl.define do
	factory :reader do
		email { Faker::Internet.email }
		first_name { Faker::Name.first_name}
		last_name { Faker::Name.last_name}
	end

  factory :observation_reader do
    observation_reader '1a'
  end
end