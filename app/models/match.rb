class Match < ActiveRecord::Base
	has_many :players, :dependent => :destroy
  def current_player
  	players.where(:played => 0).first
		# a = 0
		# @match.players.each do |player| 
		#   if player.played == 0

		#     if player.try == 2
		#       player.played = 0
		#     end


		#   break
		#   end
		#   a = a + 1
  end

  def update_score score
  	player = current_player
  	if player.frames.any? # || player.frames.where(:completed => false).size == 0
  		frame = player.frames.last
  		frame.update_attributes(:try2 => score, :completed => true)
  		frame.update_score
  		player.update_attributes(:played => 1)
  	else
  		frame = player.frames.create(:try1 => score)
  		frame.update_score
  	end

  end

end
