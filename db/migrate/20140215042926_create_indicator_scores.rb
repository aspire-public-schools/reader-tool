class CreateIndicatorScores < ActiveRecord::Migration
  def change
    create_table :indicator_scores do |t|
      t.integer :domain_score_id
      t.integer :indicator_id
      t.integer :alignment_score
      t.integer :evidence_id
      t.text :comments
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
