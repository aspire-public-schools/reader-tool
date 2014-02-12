class CreateObservations < ActiveRecord::Migration
  def up
    create_table :observations do |t|
      t.integer :observations_group_id
      t.integer :employee_id_observer
      t.integer :employee_id_learner
      t.string :alignment_overall
      t.string :quality_overall
      t.decimal :correlation
      t.decimal :average_difference
      t.decimal :percent_correct
      t.string :error_pattern_1
      t.string :error_pattern_2
      t.string :error_pattern_3
      t.integer :reader_number

      t.timestamps
    end
  end

  def down
    drop_table :observations
  end
end
