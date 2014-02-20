class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.string :number
      t.string :description
      t.belongs_to :domain
    end
  end
end
