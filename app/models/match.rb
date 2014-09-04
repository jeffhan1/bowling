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
    if player.bonus != 0
      if player.bonus == 1
        frame = player.frames.last
        frame.update_attributes(:try3 => score, :completed => true)
        s = check_score(score)
        s = player.read_attribute(:score) + s
        player.update_attributes(:score => s)
        player.update_attributes(:played => 1)
        player.update_frame_scores
      else
        frame = player.frames.last
        if frame.read_attribute(:try2) == nil
          frame.update_attributes(:try2 => score)
          s = check_score(score)
          s = player.read_attribute(:score) + s
          player.update_attributes(:score => s)
        else
          frame.update_attributes(:try3 => score, :completed => true)
          s = check_score(score)
          s = player.read_attribute(:score) + s
          player.update_attributes(:score => s)
          player.update_attributes(:played => 1)
          player.update_frame_scores
        end
      end
      return
    end

  	if player.frames.any? 
      if player.frames.where(:completed => false).size > 0
  		  frame = player.frames.last
  		  frame.update_attributes(:try2 => score, :completed => true)
        s = check_score(score)
        if (frame.read_attribute(:try1) + score.to_i == 10)
          s = '/'
          if (self.frame == 10)
            player.update_attributes(:bonus => 1)
            s = player.read_attribute(:score) + s
            player.update_attributes(:score => s)
            player.update_attributes(:played => 0)
            return
          end
        end
        s = player.read_attribute(:score) + s
  		  player.update_attributes(:score => s)
  		  player.update_attributes(:played => 1)
        player.update_frame_scores
      else
        frame = player.frames.create(:try1 => score, :completed => false, :number => self.frame, :total => 0)
        s = check_score(score)
        if (s == 'X')
          if (self.frame == 10)
            player.update_attributes(:bonus => 2)
            s = player.read_attribute(:score) + s
            player.update_attributes(:score => s)
            player.update_attributes(:played => 0)
            return
          else
            frame = player.frames.last
            frame.update_attributes(:completed => true)
            player.update_attributes(:played => 1)
            s = player.read_attribute(:score) + s
            player.update_attributes(:score => s)
            player.update_frame_scores
          end
        else 
          s = player.read_attribute(:score) + s
          player.update_attributes(:score => s)
        end
      end


  	else
  		frame = player.frames.create(:try1 => score, :completed => false, :number => self.frame, :total => 0)

      s = check_score(score)
      if (s == 'X')
          frame = player.frames.last
          frame.update_attributes(:completed => true)
          player.update_attributes(:played => 1)
          s = player.read_attribute(:score) + s
          player.update_attributes(:score => s)
          player.update_frame_scores
      else 
  		  s = player.read_attribute(:score) + s
        player.update_attributes(:score => s)
      end
  	end

    end_of_round

  end


  def end_of_round
    if !end_of_game && players.where(:played => 0).size == 0
      players.update_all(:played => 0)
      if self.frame < 10
        frame_number = self.frame + 1;   
        self.update_attributes(:frame => frame_number)
      end
    end
  end

  def end_of_game
    if self.frame == 10
      if players.where(:played => 0).size == 0
        return true
      end
    end
  end

  def winner
    p = nil
    max = 0
    players.each do |player|
      if max < player.get_points
        max = player.get_points
        p = player
     end
   end
   return p.name
  end


  def check_score score
    if score == '10'
      return 'X'
    elsif score == '0'
      return '-'
    else
      return score
    end
  end

  def started
    players.each do |player| 
      if player.frames.any?
        return true
      end
    end
    return false
  end

  validates :name, :presence => true
  validates :name, :uniqueness => true

end
