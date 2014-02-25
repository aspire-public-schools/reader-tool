class CreateEvidenceScores < ActiveRecord::Migration
  def change
    create_table :evidence_scores do |t|
      t.integer :indicator_score_id
      t.string :description
      t.boolean :quality, :default => true
      t.boolean :alignment, :default => true
    end
  end
end
