class ScoreController < ApplicationController

	def update

		@match = Match.find(session[:match_id])
		@match.update_score(params[:score][:value])

    respond_to do |format|
      format.html { redirect_to(@match) }
      format.js 
    end

	end

end
