class ScoreController < ApplicationController

	def update
		 @match = Match.find(session[:match_id])
		 @match.update_score(params[:score][:value])

		 redirect_to(@match)
	end

end
