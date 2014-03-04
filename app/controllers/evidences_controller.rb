class EvidencesController < ApplicationController

  def index
    # observation = ObservationRead.find(params[:observation_id])
    # domain = DomainScore.find(params[:domain_id])
    @indicator_score = IndicatorScore.find(params[:indicator_id])
    # @evidence_score = @indicator.evidence_scores
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
      params[:evidence_scores].keys.each do |score_id|
        quality = params[:evidence_scores][score_id][:quality] || false
        alignment = params[:evidence_scores][score_id][:alignment] || false
        EvidenceScore.update(score_id,{quality: quality, alignment: alignment})
      end
      redirect_to observation_domain_indicator_evidences_path
  end
end
