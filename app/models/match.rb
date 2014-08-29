class Match < ActiveRecord::Base
	has_many :players, :dependent => :destroy

  def current_player_name
  	players.where(:played => 0).first.name
  end

  def current_player
		players.where(:played => 0).first
  end

  def update_score score
  	player = current_player
  	if player.frames.any? 
      if player.frames.where(:completed => false).size == 0
  		  frame = player.frames.last
  		  frame.update_attributes(:try2 => score, :completed => true)
  		  #frame.update_score
  		  #player.update_attributes(:played => 1)
      end
  	else
  		frame = player.frames.create(:try1 => score)
  		#frame.update_score
  	end

  end

end
