class ScoreController < ApplicationController

	def update
		 @match = Match.find(session[:match_id])
		 @match.update_score(params[:score][:value])

		 if (@match.end_of_game)
		 	render('matches/end')
		 else
		 	redirect_to(@match)
		 end
	end

end
