class Domain_Score < ActiveRecord::Base
  belongs_to :observation_read
  belongs_to :domain
end