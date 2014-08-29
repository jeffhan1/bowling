class Player < ActiveRecord::Base
	belongs_to :match, :dependent => :destroy
	has_many :games
end
