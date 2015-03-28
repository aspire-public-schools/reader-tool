class CreateEvidenceScores < ActiveRecord::Migration

  def change
    create_table "evidence_scores", :force => true do |t|
      t.integer  "indicator_score_id"
      t.integer  "evidence_id"
      t.text     "description"
      t.text     "comments"
      t.boolean  "quality"
      t.boolean  "alignment"
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

end
