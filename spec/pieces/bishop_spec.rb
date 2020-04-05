require './lib/pieces/bishop.rb'
require './lib/board.rb'

RSpec.describe Bishop do
  context "when the bishop is the only piece" do
    describe "#possible_moves" do
      it "returns a list of all possible moves for a bishop at the border" do
        board = double("Board")
        square = double("Square")
        allow(board).to receive(:[]).and_return(square)
        # set all the squares in the board as empty squares
        allow(square).to receive(:occupied?).and_return(false)

        bishop = Bishop.new(position: [7, 5], color: "w")
        moves = bishop.possible_moves(board)

        expect(moves).to match_array([
          [6, 4], [5, 3], [4, 2], [3, 1], [2, 0],
          [6, 6], [5, 7]
        ])
      end

      it "returns a list of all possible moves for a bishop in the middle" do
        board = double("Board")
        square = double("Square")
        allow(board).to receive(:[]).and_return(square)
        # set all the squares in the board as empty squares
        allow(square).to receive(:occupied?).and_return(false)

        bishop = Bishop.new(position: [3, 4], color: "b")
        moves = bishop.possible_moves(board)

        expect(moves).to match_array([
          [4, 5], [5, 6], [6, 7],
          [4, 3], [5, 2], [6, 1], [7, 0],
          [2, 5], [1, 6], [0, 7],
          [2, 3], [1, 2], [0, 1]
        ])
      end
    end
  end

  context "when the bishop is not the only piece" do
    describe "#possible_moves" do
      it "returns a list of possible moves" do
        board = Board.new
        board.place_piece([3, 5], piece: :Rook, color: "b")
        board.place_piece([5, 2], piece: :Rook, color: "w")
        board.place_piece([6, 4], piece: :Bishop, color: "w")

        board.place_piece([5, 3], piece: :Bishop, color: "b")
        moves = board[5, 3].piece.possible_moves(board)

        expect(moves).to match_array([
          [6, 4],
          [6, 2], [7, 1],
          [4, 2], [3, 1], [2, 0],
          [4, 4]
        ])
      end
    end
  end
end
