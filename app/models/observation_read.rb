class ObservationRead < ActiveRecord::Base
  has_many :domain_scores
  belongs_to :reader

  def domains
    domain_scores.joins(:domain).
      select("distinct domains.id as id, domains.description as description").
        map { |d| [d.id, d.description] }
  end
end