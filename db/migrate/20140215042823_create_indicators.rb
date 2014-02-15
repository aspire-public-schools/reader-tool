class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.integer :number
      t.string :description
    end
  end
end
