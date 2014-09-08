require 'spec_helper'
require 'player'

describe Player do    #'describe the behavior of the Player class'

  describe "#points" do
  	it "gets the correct total points" do
      player = FactoryGirl.create(:player)
      player.score = "1/45-1--9-XX15-/63"
      expect(player.get_points).to eq(101)
      
      player.score = "5/5/5/5/5/5/5/5/5/5/5"
      expect(player.get_points).to eq(150)

      player.score = "XXXXXXXXXXXX"
      expect(player.get_points).to eq(300)

      player.score = "9-9-9-9-9-9-9-9-9-9-"
      expect(player.get_points).to eq(90)
  	end

    #it "follows the scoring rules" do
    #  player.score = "X/"
    #  expect(player).to eq(false)

    #  player.score = "X56"
    #  expect(player).to eq(false)

    #  player.score = "XXXXXXXXXXXXX"
    #  expect(player).to eq(false)
    #end

  end

end