require './lib/player.rb'

RSpec.describe Player do
  context 'when creating a new player' do
    it "has the color white" do
      player = Player.new(color: "w")

      expect(player.color).to eq "w"
    end
  end

  describe "#fetch_instructions" do

    it "tells the player instructions for the turn" do
      p = Player.new(color: "w")
      allow(p).to receive(:gets).and_return("Nf3\n")

      expect { p.fetch_instructions }.to output(/White/).to_stdout
    end

    it "keeps asking until some input is given" do
      p = Player.new(color: "w")
      allow(p).to receive(:gets).and_return("\n", "\n", "Bg5\n")

      instructions = p.fetch_instructions

      expect(instructions).to eq "Bg5"
    end
  end
end
