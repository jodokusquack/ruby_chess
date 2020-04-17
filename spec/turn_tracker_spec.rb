require './lib/turn_tracker.rb'

RSpec.describe TurnTracker do
  describe "#current" do
    it "returns the player who's turn it is" do
      pW = double("white_player", :color => "w")
      pB = double("black_player", :color => "b")
      t = TurnTracker.new(players: [pW, pB])

      player = t.current

      expect(player.color).to eq "w"
    end

    it "can be initialized with black as the current color" do
      pW = double("white_player", :color => "w")
      pB = double("black_player", :color => "b")
      t = TurnTracker.new(players: [pW, pB], current_color: "b")

      player = t.current

      expect(player.color).to eq "b"
    end
  end

  describe "#next" do
    it "can change the player color from 'w' to 'b'" do
      pW = double("white_player", :color => "w")
      pB = double("black_player", :color => "b")
      t = TurnTracker.new(players: [pW, pB])

      player = t.current
      next_player = t.next

      expect(player.color).to eq "w"
      expect(next_player.color).to eq "b"
      expect { t.next }.to change(t, :current)
    end
  end
end
