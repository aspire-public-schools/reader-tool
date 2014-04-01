class EvidencesController < ApplicationController
  include EvidenceScoreHelper

  def index
    @indicator_score = IndicatorScore.find(params[:indicator_id])
    if @indicator_score
      render :json => { :evidence_list => render_to_string( :partial => "evidence_score_form", locals: { :indicator_score => @indicator_score} ) }
    else
      render :json => { :error => reader.errors.full_messages.join(", ")}, :status => :unprocessable_entity
    end
  end

  def score
      @reader = current_user
      @observation_read = @reader.observation_reads.find(params[:observation_id])
      params[:evidence_scores].keys.each do |score_id|
        quality = params[:evidence_scores][score_id][:quality] || false
        alignment = params[:evidence_scores][score_id][:alignment] || false
        @evidence_score_update = EvidenceScore.update(score_id,{quality: quality, alignment: alignment})
      end
        @indicator_score_update = IndicatorScore.update(params[:indicator_id], {comments: params[:comments] })
        @indicator_score = IndicatorScore.find(params[:indicator_id])
      if @evidence_score_update
        @get_section_scores = get_section_scores(params[:observation_id])
        @domain_percentages = get_percentages(params[:observation_id])
        @domain_percentages_sort = @domain_percentages.sort! { |a,b| a.number <=> b.number }
          render :json => { :info => "Godzilla says it's saved!",
                            :submit_list => render_to_string( :partial => "evidence_score_form",
                                            locals: { :indicator_score => @indicator_score } ),
                            :domain_percentages => render_to_string(:partial => 'observations/domain_percentages'),
                                            locals: { :domain_percentages_sort => @domain_percentages_sort, :get_section_scores => @get_section_scores, :observation_read => @observation_read} }
        else
          render :json => { :error => reader.errors.full_messages.join(", ")}, :status => :unprocessable_entity
      end
  end
end