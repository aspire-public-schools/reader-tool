class CreateReader < ActiveRecord::Migration
  def change
  	create_table :readers do |t|
  		t.integer :employee_number
  		t.string :first_name
  		t.string :last_name
      t.string :email
  	end
  end
end

before_validation: :reader_name |name| name.downcase