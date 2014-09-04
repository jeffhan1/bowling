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
					elsif score[i+2] == '/'
						points = points + 10-score[i+1].to_i
					elsif score[i+2] != '-'
						points = points + score[i+2].to_i
					end
				end
			
			elsif score[i] == '/'
				count += 1

				if count > 10
					return points
				end

				points = points + (10-score[i-1].to_i)

				if i+1 < score.length
					if score[i+1] == 'X'
						points = points + 10
					elsif score[i+1] != '-'
						points = points + score[i+1].to_i
					end
				end

			else
				if count > 10 || count == 10 && score[i-1] == '/'
					return points
				end

				if i > 0 && i%2 != 0
					count += 1
				end

				if score[i] != '-'
					points = points + score[i].to_i
				end

			end

		end
		return points

	end

	def update_frame_scores

		count = 0
		frames.update_all(:total => 0)
		for i in 0..score.length-1

			if score[i] == 'X'

				count += 1

				if count >= 10
					count = 10
					frame = self.frames.where(:number => count).first
					temp_total = 10
					if i+1 < score.length
						if score[i+1] == 'X'
							temp_total = temp_total + 10
						elsif score[i+1] != '-'
							temp_total = temp_total + score[i+1].to_i
						end
					end

					if i+2 < score.length
						if score[i+2] == 'X'
							temp_total = temp_total + 10
						elsif score[i+2] == '/'
						 	temp_total = temp_total + 10-score[i+1].to_i
						elsif score[i+2] != '-'
							temp_total = temp_total + score[i+2].to_i
						end
					end
					prev_frame = self.frames.where(:number => count-1).first
					prev_total = prev_frame.read_attribute(:total)
					frame.update_attributes(:total => prev_total + temp_total)
					return
				end

				frame = self.frames.where(:number => count).first
				temp_total = 10

				if i+1 < score.length
					if score[i+1] == 'X'
						temp_total = temp_total + 10
					elsif score[i+1] != '-'
						temp_total = temp_total + score[i+1].to_i
					end
				end

				if i+2 < score.length
					if score[i+2] == 'X'
						temp_total = temp_total + 10
					elsif score[i+2] == '/'
					 	temp_total = temp_total + 10-score[i+1].to_i
					elsif score[i+2] != '-'
						temp_total = temp_total + score[i+2].to_i
					end
				end

				if count > 1
					prev_frame = self.frames.where(:number => count-1).first
					prev_total = prev_frame.read_attribute(:total)
					frame.update_attributes(:total => prev_total + temp_total)
				else
					frame.update_attributes(:total => temp_total)
				end
			
			elsif score[i] == '/'

				if count >= 10
					count = 10
					frame = self.frames.where(:number => count).first
					temp_total = 10
					if i+1 < score.length
						if score[i+1] == 'X'
							temp_total = temp_total + 10
						elsif score[i+1] != '-'
							temp_total = temp_total + score[i+1].to_i
						end
					end
					prev_frame = self.frames.where(:number => count-1).first
					prev_total = prev_frame.read_attribute(:total)
					frame.update_attributes(:total => prev_total + temp_total)
					return
				end

				frame = self.frames.where(:number => count).first
				temp_total = 10

				if i+1 < score.length
					if score[i+1] == 'X'
						temp_total = temp_total + 10
					elsif score[i+1] != '-'
						temp_total = temp_total + score[i+1].to_i
					end
				end

				if count > 1
					prev_frame = self.frames.where(:number => count-1).first
					prev_total = prev_frame.read_attribute(:total)
					frame.update_attributes(:total => prev_total + temp_total)
				else
					frame.update_attributes(:total => temp_total)
				end

			else

				if i == 0 
					count = 1
				end

				if i > 0
					if score[i-1] == 'X' || score[i-1] == '/'
						count += 1
					elsif score[i-1] == '-'
						counter = 0
						j = i-1
						while j >= 0 && score[j] == '-'
							counter += 1
							j -= 1
						end
						if counter%2 == 0
							count +=1
						end
					else
						counter = 0
						j = i-1
						while j >= 0 && score[j] != 'X'
							counter +=1
							j -= 1
						end
						if counter%2 == 0
							count +=1
						end
					end
				end

				if count > 10
					count = 10
				end

				frame = self.frames.where(:number => count).first
				if i > 0 && i%2 != 0
					temp_total = score[i-1].to_i + score[i].to_i
				else
					temp_total = score[i].to_i
				end

				if count > 1
					prev_frame = self.frames.where(:number => count-1).first
					prev_total = prev_frame.read_attribute(:total)
					frame.update_attributes(:total => prev_total + temp_total)
				else
					frame.update_attributes(:total => temp_total)
				end

			end
		end

	end




	validates :name, :presence => true
	validates :name, :uniqueness => true




end
