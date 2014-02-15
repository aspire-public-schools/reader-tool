class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.integer :number
      t.string :description
    end
  end
end
