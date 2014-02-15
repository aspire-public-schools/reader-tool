class CreateIndicatorScores < ActiveRecord::Migration
  def change
    create_table :indicator_scores do |t|
      t.integer :domain_scores_id
      t.integer :indicator_id
      t.integer :alignment_score
    end
  end
end
