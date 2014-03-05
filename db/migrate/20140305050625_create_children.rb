class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.integer :parent_id
      t.boolean :attr1
      t.boolean :attr2
    end
  end
end
