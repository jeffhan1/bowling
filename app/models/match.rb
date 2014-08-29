class Match < ActiveRecord::Base
	has_many :players, :dependent => :destroy
end
