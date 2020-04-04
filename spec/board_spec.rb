require './lib/board.rb'

RSpec.describe Board do

  describe "#place_piece" do
    it "creates a new piece" do
      board = Board.new
      compare_rook = Rook.new(position: [6, 2], color: "b")

      result = board.place_piece([6, 2], piece: :Rook, color: "b")

      expect(result).to eq true
      expect(board.black_pieces).to match_array([compare_rook])
    end

    it "places the piece on the board" do
      board = Board.new
      compare_rook = Rook.new(position: [2, 6], color: "w")

      expect { board.place_piece([2, 6], piece: :Rook, color: "w") }.to change(
        board[2, 6], :piece).from(nil).to(compare_rook)
    end
  end

  describe "#move" do
    xit "moves a piece from one to another position" do
      board = Board.new
      board.place_piece([4, 4], piece: :rook, color: "w")
    end

    it "returns false if the end position is out of bounds"

    it "returns false if the end position is not a legal move"
  end
end
