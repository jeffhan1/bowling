class Player < ActiveRecord::Base
	belongs_to :match
	has_many :frames

	def get_points

		points = 0
		count = 0

		for i in 0..score.length-1

			if score[i] == 'X'

				count += 1
				if count > 10
					return points
				end


				points = points + 10
				if i+1 < score.length

					if score[i+1] == 'X'
						points = points + 10
					elsif score[i+1] != '-'
						points = points + score[i+1].to_i
					end
				end

				if i+2 < score.length
					if score[i+2] == 'X'
						points = points + 10
					elsif score[i+2] != '-'
						points = points + score[i+2].to_i
					end
				end
			
			elsif score[i] == '/'
				count += 1

				points = points + (10-score[i-1].to_i)
				if i+1 < score.length
					if score[i+1] == 'X'
						points = points + 10
					elsif score[i+1] != '-'
						points = points + score[i+1].to_i
					end
				end

			else
				if count == 10
					return points
				end

				if i > 0 && i%2 != 0
					count += 1
				end
				points = points + score[i].to_i
			end

		end
		return points

	end


end
