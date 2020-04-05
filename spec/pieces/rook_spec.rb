require './lib/pieces/rook.rb'
require './lib/board.rb'

RSpec.describe Rook do
  context "white Rook at the border" do

    subject(:rook) { Rook.new(position:[4, 0], color: "w") }

    describe "#possible_moves" do
      it "returns a list of possible moves" do
        board = double("Board")
        square = double("Square")
        allow(board).to receive(:[]).and_return(square)
        # set all the squares in the board as empty squares
        allow(square).to receive(:occupied?).and_return(false)

        moves = rook.possible_moves(board)

        expect(moves).to match_array([
          [0, 0],
          [1, 0],
          [2, 0],
          [3, 0],
          [5, 0],
          [6, 0],
          [7, 0],
          [4, 1],
          [4, 2],
          [4, 3],
          [4, 4],
          [4, 5],
          [4, 6],
          [4, 7],
        ])
      end
    end
  end

  context "is white and in the middle with other pieces on board" do
    describe "#possible_moves" do
      it "returns a list of possible moves" do
        board = Board.new
        board.place_piece([1, 4], piece: :Rook, color: "b")
        board.place_piece([4, 5], piece: :Rook, color: "w")

        board.place_piece([4, 4], piece: :Rook, color: "w")
        moves = board[4, 4].piece.possible_moves(board)

        expect(moves).to match_array([
          [1, 4], [2, 4], [3, 4],
          [5, 4], [6, 4], [7, 4],
          [4, 3], [4, 2], [4, 1], [4, 0]
        ])
      end
    end
  end
end
