require './lib/square.rb'

RSpec.describe Square do
  describe "#piece" do
    it "returns the piece on the square" do
      new_piece = double("Piece")
      s = Square.new(color: "w", piece: new_piece)

      expect(s.piece).to eq new_piece
    end
  end

  context "when the square is free" do
    describe "#occupied?" do
      it "returns false" do
        s = Square.new(color: "w")

        expect(s.occupied?).to eq false
      end
    end
  end

  context "when the square is occupied by a piece" do
    describe "#occupied?" do
      it "returns true" do
        s = Square.new(color: "w")
        new_piece = double("Piece")

        s.piece = new_piece

        expect(s.occupied?).to eq true
      end
    end

    describe "#to_s" do
      it "returns #to_s of the piece" do
        new_piece = double("Piece")
        allow(new_piece).to receive(:to_s)
        s = Square.new(color: "w", piece: new_piece)

        print s

        expect(new_piece).to have_received(:to_s)
      end
    end
  end

end
