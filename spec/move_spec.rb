require './lib/move.rb'

RSpec.describe Move do
  describe "#en_passant?" do
    it "correctly tells if a piece can be captured en passant" do
      pawn = double("Pawn")
      allow(pawn).to receive(:instance_of?).with(Pawn).and_return(true)
      m = Move.new(pawn, from: [3, 1], to: [3, 3])

      expect(m.en_passant?).to eq true
    end

    it "correctly tells if a piece cannot be captured en passant" do
      pawn = double("Pawn")
      allow(pawn).to receive(:instance_of?).with(Pawn).and_return(true)

      m = Move.new(pawn, from: [4, 4], to: [4, 5])

      expect(m.en_passant?).to eq false
    end
  end
end
