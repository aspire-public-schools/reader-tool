class EvidencesController < ApplicationController

  def index
    # @domains = @observation_read.domain_scores
    # observation = ObservationRead.find(params[:observation_id])
    # domain = DomainScore.find(params[:domain_id])
    @indicator_score = IndicatorScore.find(params[:indicator_id])
    # @evidence_score = @indicator.evidence_scores
    if @indicator_score
      render :json => { :evidence_list => render_to_string( :partial => "evidence_score_form", locals: { :indicator_score => @indicator_score} ), :domain_percentages => render_to_string( :partial => 'observations/domain_percentages'), locals: { :domain_percentages_sort => @domain_percentages_sort} }
    else
      render :json => { :error => reader.errors.full_messages.join(", ")}, :status => :unprocessable_entity
    end
  end

  def score
      params[:evidence_scores].keys.each do |score_id|
        quality = params[:evidence_scores][score_id][:quality] || false
        alignment = params[:evidence_scores][score_id][:alignment] || false
        @evidence_score_update = EvidenceScore.update(score_id,{quality: quality, alignment: alignment})
      end
        @indicator_score_update = IndicatorScore.update(params[:indicator_id], {comments: params[:comments] })
        @indicator_score = IndicatorScore.find(params[:indicator_id])
        if @evidence_score_update
          render :json => { :submit_list => render_to_string( :partial => "evidence_score_form", locals: { :indicator_score => @indicator_score } ) }
        else
          render :json => { :status => :unprocessable_entity }
      end
  end
end
