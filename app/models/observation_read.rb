class ObservationRead < ActiveRecord::Base
  attr_accessible :document_quality, :document_alignment, :live_alignment, :live_quality, :observation_group_id,:employee_id_observer, :employee_id_learner, :correlation, :average_difference, :percent_correct, :reader_id, :created_at, :updated_at, :reader_number, :observation_status
  has_many :domain_scores
  belongs_to :reader

  def domains
    domain_scores.joins(:domain).
      select("distinct domains.id as id, domains.description as description").
        map { |d| [d.id, d.description] }
  end


  def grader?
    reader_number == '1a' || '1b'
  end

  def supervisor?
    !grader?
  end

  def complete
    # COPY observation_read
    # COPY indicator_scores
    # COPY evidence_scores
    # p ObservationRead.last
    # p self.clone.save
    # p ObservationRead.last


    if grader?
      return submit_for_verification and copy_scores
    elsif submitted_for_varification? and supervisor?
      return verify_complete and copy_scores
    end
    false

  end

  def copy_scores
    # self.domain_scores.each do |domain_score|
    #   domain_score.indicator_scores.each do |indicator_score|
    #     p indicator_score.clone.save
    #      indicator_score.evidence_scores
    #       evidence_score.clone.save
    #   end
    # end
  end

  # def submit_for_verfication
  #   update_attributes(observation_status: 2)
  # end

  # def verify_complete
  #   update_attributes(observation_status: 3)
  # end
end


# IF @observation_read.reader_number = '1a' OR '1b' THEN SET observation_status = 2 AND Copy reader 1 scores to reader 2
    # IF @observation_read.reader_number = '2' THEN SET observation_status = 3

# keep controllers thin
# push it down into the model
# anytime you touch the model, you should have a test for it

# 1a(Domain 1+4) + 1b(Domain 2+3) = 1 observation/reader
# copy into reader 2
