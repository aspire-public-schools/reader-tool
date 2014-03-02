class EvidencesController < ApplicationController

  def index
    # observation = ObservationRead.find(params[:observation_id])
    # domain = DomainScore.find(params[:domain_id])
    @indicator = IndicatorScore.find(params[:indicator_id])
    # @evidence_score = @indicator.evidence_scores
  end

  def show

  end

  def update
      if @evidence_scores.update_attributes(params[:evidence_score.id])
        flash[:success] = "Completed"
        redirect_to
      else
        redirect_to
      end
  end

  def score
    EvidenceScore.update_all({quality: false, alignment: false}, {id: params[:evidence_score_ids]} )
    redirect_to observation_domain_indicator_evidences_path
  end

end


