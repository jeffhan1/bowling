class Player < ActiveRecord::Base
	belongs_to :match, :dependent => :destroy
	has_many :frames

	def total_score
		frames.sum(:score)
	end
end
