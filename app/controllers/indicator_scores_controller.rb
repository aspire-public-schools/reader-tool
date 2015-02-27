class IndicatorScoresController < ApplicationController

  def update
    @reader = current_user
    if Rails.env.development?
      @observation_read = ObservationRead.find(params[:observation_read_id])
    else
      @observation_read = @reader.observation_reads.find(params[:observation_read_id])
    end 
    
    if @indicator_score = IndicatorScore.find(params[:id])
      @observation_read.update_scores
      @indicator_score.update_attributes( params[:indicator_score] )
      flash[:success] = "Scores were updated."
    end

    redirect_to @observation_read    
  end

end