class CreateObservationReads < ActiveRecord::Migration
  def change
    create_table :observation_reads do |t|
      t.integer :observation_group_id
      t.string :employee_id_observer
      t.string :employee_id_learner
      t.string :alignment_overall
      t.integer :correlation
      t.integer :average_difference
      t.integer :percent_correct
      t.integer :reader_id
      t.string :error_pattern_1
      t.string :error_pattern_2
      t.string :error_pattern_3
      t.string :reader_number
      t.integer :document_alignment
      t.integer :document_quality
      t.integer :live_alignment
      t.integer :live_quality
      t.integer :observation_status
      t.boolean :flagged
      t.text    :comments
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
