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

		frames.update_all(:total => 0)
		f = frames.find(:all, :order => "id")	

		a = 0	# used for looping
		while a < f.size
			frame = f[a]
			try1 = frame.read_attribute(:try1)
			if try1 == 10
				if a == 8 
					if a+1 < f.size
						next_frame = f[a+1]
						next_try1 = next_frame.read_attribute(:try1)
						next_try2 = next_frame.read_attribute(:try2)
						temp_total = try1 + next_try1 + next_try2
						prev_total = get_prev_total(f, a-1) 
						frame.update_attributes(:total  => temp_total + prev_total) 
					else
						frame.update_attributes(:total => try1)
					end
				elsif a == 9
					try2 = frame.read_attribute(:try2)
					try3 = frame.read_attribute(:try3)
					temp_total = try1 + try2 + try3
					prev_total = get_prev_total(f, a-1) 
					frame.update_attributes(:total  => temp_total + prev_total) 
					return
				else
					#if next frame exists, get next frame
					if a+1 < f.size 		
						next_frame = f[a+1]
						next_try1 = next_frame.read_attribute(:try1)
						if next_try1 == 10
							#if next next frame exists, get next next frame
							if a+2 < f.size
								next_next_frame = f[a+2]
								next_next_try1 = next_next_frame.read_attribute(:try1)
								temp_total = next_try1 + next_next_try1 + try1
								#if previous frame exists, get previous frame
								if a-1 >= 0
									prev_total = get_prev_total(f, a-1) 
									frame.update_attributes(:total  => temp_total + prev_total) 
								else
									frame.update_attributes(:total => temp_total)
								end
							else
								if a-1 >= 0
									prev_total = get_prev_total(f, a-1) 
									frame.update_attributes(:total  => prev_total + try1 + next_try1) 
								else
									frame.update_attributes(:total => try1 + next_try1)
								end
							end
						else
							next_try2 = next_frame.read_attribute(:try2)
							temp_total = next_try1 + next_try2 + try1 
							#if previous frame exists, get previous frame
							if a-1 >= 0
								prev_total = get_prev_total(f, a-1) 
								frame.update_attributes(:total  => temp_total + prev_total) 
							else
								frame.update_attributes(:total => temp_total)
							end
						end
					else
						#if previous frame exists, get previous frame
						if a-1 >= 0
							prev_total = get_prev_total(f, a-1) 
							frame.update_attributes(:total => try1 + prev_total) 
						else
							frame.update_attributes(:total => try1)
						end
					end
				end
			else
				try2 = frame.read_attribute(:try2)
				if try2 == nil
					return
				end
				if a == 9 && try1+try2 == 10
					try3 = frame.read_attribute(:try3)
					prev_total = get_prev_total(f, a-1) 
					temp_total = try1 + try2 + try3
					frame.update_attributes(:total => temp_total + prev_total) 
					return
				end
				if try1+try2 == 10
					#if next frame exists, get next frame
					if a+1 < f.size 
						next_frame = f[a+1]	
						next_try1 = next_frame.read_attribute(:try1)
						temp_total = next_try1 + try1 + try2
						#if previous frame exists, get previous frame
						if a-1 >= 0
							prev_total = get_prev_total(f, a-1) 
							frame.update_attributes(:total  => temp_total + prev_total) 
						else
							frame.update_attributes(:total => temp_total)
						end
					else
						frame.update_attributes(:total => try1 + try2)
					end
				else
					#if previous frame exists, get previous frame
					if a-1 >= 0
						prev_total = get_prev_total(f, a-1) 
						frame.update_attributes(:total  => prev_total + try1 + try2) 
					else
						frame.update_attributes(:total => try1 + try2)
					end
				end
			end
			a += 1
		end
	end

	validates :name, :presence => true
	validates :name, :uniqueness => true


	def get_prev_total frame, number
		prev_frame = frame[number]
		prev_frame.read_attribute(:total)
	end


end
