require 'spec_helper'
require 'player'

describe Player do    #'describe the behavior of the Player class'

  describe "#points" do
  	it "gets the correct total points" do
      player = FactoryGirl.create(:player)
      player.score = "1/45-1--9-XX15-/63"
      player.get_points.should eql 101
      
      player.score = "5/5/5/5/5/5/5/5/5/5/5"
      player.get_points.should eql 150

      player.score = "XXXXXXXXXXXX"
      player.get_points.should eql 300

      player.score = "9-9-9-9-9-9-9-9-9-9-"
      player.get_points.should eql 90
  	end
  end

end