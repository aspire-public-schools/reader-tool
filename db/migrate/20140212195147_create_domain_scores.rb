class CreateDomainScores < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.integer :number
      t.string :description
    end

    create_table :domain_scores do |t|
      t.belongs_to :observation_read
      t.belongs_to :domain
      t.integer :quality_score
    end
  end
end
