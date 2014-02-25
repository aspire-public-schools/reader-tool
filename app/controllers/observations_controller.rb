class ObservationsController < ApplicationController
  include SessionHelper

  def new
    @evidence_score = EvidenceScore.new
  end


	def index
    @evidence_score = EvidenceScore.new
    # p "I'm hereeeeeeee"
    # p session
    @reader = current_user

    p "I'm here"
    p evidence_score

    # @reader.fetch_evidence_scores
    if current_user
      @observation_reads = @reader.observation_reads
    end
    @domain = Domain.all
  end

  def show
    @reader = current_user
    @observation_reads = @reader.observation_reads
    @domain = Domain.all
  end

  def evidence_score
      sql = "SELECT evds.*, inds.*
    FROM evidence_scores evds
    LEFT JOIN indicator_scores inds
         ON evds.indicator_score_id = inds.id
    LEFT JOIN domain_scores doms
         ON inds.domain_score_id = doms.id
    LEFT JOIN observation_reads obsr
         ON doms.observation_read_id = obsr.id
    LEFT JOIN indicators ind
    ON inds.indicator_id = ind.id

    WHERE
    observation_read_id = 9
    AND ind.code = '1.1A'
    ORDER BY obsr.id, ind.code"

    @EvidenceScores = EvidenceScore.find_by_sql(sql)
  end

end


