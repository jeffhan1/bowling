class Frame < ActiveRecord::Base
	belongs_to :player

	def completed?
		try1 && try2
	end
end
