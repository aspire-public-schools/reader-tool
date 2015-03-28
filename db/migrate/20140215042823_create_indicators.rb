class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.string :code
      t.string :description
      t.integer :domain_id
    end
  end
end
