class EvidencesController < ApplicationController

  def index
    # @domains = @observation_read.domain_scores
    # observation = ObservationRead.find(params[:observation_id])
    # domain = DomainScore.find(params[:domain_id])
    @indicator_score = IndicatorScore.find(params[:indicator_id])
    # @evidence_score = @indicator.evidence_scores
    if @indicator_score
      render :json => { :evidence_list => render_to_string( :partial => "evidence_score_form", locals: { :indicator_score => @indicator_score} ) }
    else
      render :json => { :status => :unprocessable_entity }
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
