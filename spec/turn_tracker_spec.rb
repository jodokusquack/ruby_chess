require './lib/turn_tracker.rb'

RSpec.describe TurnTracker do
  describe "#current" do
    it "returns the player who's turn it is" do
      t = TurnTracker.new

      player_color = t.current

      expect(player_color).to eq "w"
    end

    it "can be initialized with black as the current color" do
      t = TurnTracker.new(current: "b")

      color = t.current

      expect(color).to eq "b"
    end
  end

  describe "#next" do
    it "can change the player color from 'w' to 'b'" do
      t = TurnTracker.new

      color = t.current
      next_color = t.next

      expect(color).to eq "w"
      expect(next_color).to eq "b"
      expect { t.next }.to change(t, :current).from("b").to("w")
    end
  end
end
