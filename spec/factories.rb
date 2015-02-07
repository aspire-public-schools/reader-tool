FactoryGirl.define do
	factory :reader do
		email { Faker::Internet.email }
		first_name { Faker::Name.first_name}
		last_name { Faker::Name.last_name}
	end

  factory :observation_read do
    observation_group_id { rand(1..10) }
    reader_number { %w[1a 1b 2].shuffle.first } 
    observation_status { 2 } # 1 = waiting 2 = ready 3 = finished
    employee_id_observer { rand(1..10) }
    employee_id_learner { rand(1..10) }    
  end

end