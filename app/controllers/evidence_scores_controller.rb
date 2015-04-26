class EvidenceScoresController < ApplicationController

  def index
    if @indicator_score = IndicatorScore.find(params[:indicator_score_id]) 
      @observation_read = @indicator_score.observation_read
      # p @evidence_scores  = @indicator_score.evidence_scores
      render json: { evidence_list: render_to_string( partial: "evidence_score_form" ) }
    else
      render json: { error: reader.errors.full_messages.join(", ")}, status: :unprocessable_entity
    end
  end

end
