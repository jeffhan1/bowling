class Frame < ActiveRecord::Base
	belongs_to :player
  def check_score score
    if score == '10'
      return 'X'
    elsif score == '0'
      return '-'
    else
      return score
    end
  end
end
