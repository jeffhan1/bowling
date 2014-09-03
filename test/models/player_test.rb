require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
	test "player name must not be empty" do
		player = Player.new
		assert player.errors[:name].any?
	end
end
