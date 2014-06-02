class CreateReader < ActiveRecord::Migration
  def change
  	create_table :readers do |t|
  		t.integer :employee_number
  		t.string :first_name
  		t.string :last_name
      t.string :email
      t.integer :is_reader1a
      t.integer :is_reader1b
      t.integer :is_reader2
  	end
  end
end
