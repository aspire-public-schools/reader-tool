class CreateReader < ActiveRecord::Migration
  def up
  	create_table :readers do |t|
  		t.integer :empolyeenumber
  		t.string :first_name
  		t.string :last_name
  		t.string :password_digest
  	end
  end

  def down
  	drop_table :readers
  end
end
