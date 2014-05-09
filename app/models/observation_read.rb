class ObservationRead < ActiveRecord::Base

  attr_accessible :document_quality, :document_alignment, :live_alignment, :live_quality, :observation_status, :id, :observation_group_id, :employee_id_observer, :employee_id_learner, :correlation, :average_difference, :percent_correct, :reader_id, :created_at, :updated_at, :reader_number, :comments
  has_many :domain_scores
  has_many :indicator_scores, :through => :domain_scores
  has_many :evidence_scores, :through => :indicator_scores
  belongs_to :reader


  def domains
    domain_scores.joins(:domain).
      select("distinct domains.id as id, domains.description as description").
        map { |d| [d.id, d.description] }
  end

  def copy_to_reader2
    r1_observation_read = self
    r2_observation_read = ObservationRead.where("observation_group_id = ? AND reader_number = ?", self.observation_group_id, '2').first

    if reader_number == '1a'
      certification_scores = {:document_quality => self.document_quality, :document_alignment => self.document_alignment}
    elsif reader_number == '1b'
      certification_scores = {:live_quality => self.live_quality, :live_alignment => self.live_alignment}
    end

    r2_observation_read.update_attributes(certification_scores)
    if r2_observation_read.comments == nil
      comments = "#{self.reader_number}: #{self.comments}"
    else
      comments = "#{self.reader_number}: #{self.comments}\n#{r2_observation_read.comments}"
    end
    r2_observation_read.update_attributes(comments: comments)

    if reader_number == '1a'
      r2_indicator_scores = r2_observation_read.indicator_scores.where("domain_scores.domain_id IN (1,4)").order(:indicator_id)
    elsif reader_number == '1b'
      r2_indicator_scores = r2_observation_read.indicator_scores.where("domain_scores.domain_id IN (2,3)").order(:indicator_id)
    end

    if reader_number == '1a' || reader_number == '1b'
    # this copies reader 1 scores into reader 2
        r1_indicator_scores = r1_observation_read.indicator_scores.order(:indicator_id)

      r2_indicator_scores.count.times{ |i|
          r2_indicator_scores[i].update_attributes(:comments => r1_indicator_scores[i].comments )

          sorted_r1_indicator_scores = r1_indicator_scores[i].evidence_scores.order(:description)
          sorted_r2_indicator_scores = r2_indicator_scores[i].evidence_scores.order(:description)

            r1_indicator_scores[i].evidence_scores.count.times { |j|

                 new_scores = {:quality => sorted_r1_indicator_scores[j].quality, :alignment => sorted_r1_indicator_scores[j].alignment }

                 sorted_r2_indicator_scores[j].update_attributes(new_scores)

            }
        }
    end
  end

  def update_status
    update_attributes(observation_status: 3)
    completed_group_reads = ObservationRead.where(observation_group_id: self.observation_group_id, reader_number: ['1a','1b'], observation_status: 3)
    if completed_group_reads.count == 2
      read_2 = ObservationRead.where(observation_group_id: self.observation_group_id, reader_number: '2').first
      read_2.update_attributes(observation_status: 2)
    end
  end

  def document_quality_string
    doc_quality_string = document_quality.to_s
    if document_quality == 1
      doc_quality_string.replace "NOTCERT"
    elsif document_quality == 2
      doc_quality_string.replace "CERT"
    end
  end

  def document_alignment_string
    doc_align_string = document_alignment.to_s
    if document_alignment == 1
      doc_align_string.replace "NOTCERT"
    elsif document_alignment == 2
      doc_align_string.replace "CERT"
    end
  end

  def live_quality_string
    live_quality_string = live_quality.to_s
    if live_quality == 1
      live_quality_string.replace "NOTCERT"
    elsif live_quality == 2
      live_quality_string = live_quality.to_s
      live_quality_string.replace "CERT"
    end
  end

  def live_alignment_string
    live_align_string = live_alignment.to_s
    if live_alignment == 1
      live_align_string.replace "NOTCERT"
    elsif live_alignment == 2
      live_align_string.replace "CERT"
    end
  end


end




# new_indicator_scores.each do |indicator_score|
#   indicator_score.evidence_scores.each do |evidence_score|
#     evidence_square.quality = 1
#   end
# end


# for indicator_score in new_indicator_scores



    # p old_evidence_scores = self.evidence_sco
    # p new_evidence_scores = EvidenceScores.new


     #old_observation_read.save
    #p new_observation_read
    # p copy_scores

    # COPY observation_read
    # COPY indicator_scores
    # COPY evidence_scores
    # p ObservationRead.last
    # p self.clone.save
    # p ObservationRead.last


    # if grader?
    #   return submit_for_verification and copy_scores
    # elsif submitted_for_verification? and supervisor?
    #   return verify_complete and copy_scores
    # end
    # false



  # def copy_scores
  #   # self.domain_scores.each do |domain_score|
  #   #   domain_score.indicator_scores.each do |indicator_score|
  #   #   p indicator_score.clone.save
  #   #      indicator_score.evidence_scores
  #   #       evidence_score.clone.save
  #   #   end
  #   # end
  # end

  # # def test
  # #   2s_scores = evidence_scores.where(reader_number: 2, observation_group_id: self.observation_group_id)


  # def submit_for_verfication
  #   update_attributes(observation_status: 2)
  # end

  # def submitted_for_verification?
  #   true
  # end

  # def verify_complete
  #   update_attributes(observation_status: 3)
  # end




# IF @observation_read.reader_number = '1a' OR '1b' THEN SET observation_status = 2 AND Copy reader 1 scores to reader 2
    # IF @observation_read.reader_number = '2' THEN SET observation_status = 3

# keep controllers thin
# push it down into the model
# anytime you touch the model, you should have a test for it

# 1a(Domain 1+4) + 1b(Domain 2+3) = 1 observation/reader
# copy into reader 2

