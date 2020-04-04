require './lib/pieces/piece.rb'

RSpec.describe Piece do
  describe "#position" do
    it "creates an object with a position, col and row variables" do
      p = Piece.new(position: [3, 5], color: "w")

      expect(p.position).to eq [3, 5]
      expect(p.col).to eq 3
      expect(p.row).to eq 5
    end
  end

  describe "#col=" do
    it "sets the column and updates position accordingly" do
      p = Piece.new(position: [0, 0], color: "w")

      p.col = 4

      expect(p.col).to eq 4
      expect(p.position).to eq [4, 0]
    end
  end

  describe "#row=" do
    it "sets the row and updates position accordingly" do
      p = Piece.new(position: [0, 0], color: "w")

      p.row = 7

      expect(p.row).to eq 7
      expect(p.position).to eq [0, 7]
    end
  end
end
