require './lib/pieces/king.rb'
require './lib/board.rb'

RSpec.describe King do
  context "when the King is the only piece" do
    describe "#possible_moves" do
      it "returns a list of all possible moves for a Knight at the border" do
        board = double("Board")
        square = double("Square")
        allow(board).to receive(:[]) do |col, row|
          if col < 0 or col > 7
            nil
          elsif row < 0 or row > 7
            nil
          else
            square
          end
        end
        # set all the squares in the board as empty squares
        allow(square).to receive(:occupied?).and_return(false)

        king = King.new(position: [4, 0], color: "w")
        moves = king.possible_moves(board)

        expect(moves).to match_array([
          [4, 1], [5, 1], [5, 0], [3, 0], [3, 1]
        ])
      end

      it "returns a list of all possible moves for a King in the middle" do
        board = double("Board")
        square = double("Square")
        allow(board).to receive(:[]).and_return(square)
        # set all the squares in the board as empty squares
        allow(square).to receive(:occupied?).and_return(false)

        king = King.new(position: [5, 2], color: "b")
        moves = king.possible_moves(board)

        expect(moves).to match_array([
          [5, 3], [6, 3], [6, 2], [6, 1], [5, 1], [4, 1], [4, 2], [4, 3]
        ])
      end
    end
  end

  context "when the King is not the only piece" do
    describe "#possible_moves" do
      it "returns a list of possible moves" do
        board = Board.new
        board.place_piece([0, 5], piece: :Bishop, color: "w")
        board.place_piece([0, 6], piece: :Rook, color: "b")
        board.place_piece([1, 3], piece: :Rook, color: "w")
        board.place_piece([1, 6], piece: :King, color: "b")
        board.place_piece([2, 6], piece: :Knight, color: "w")
        board.place_piece([5, 5], piece: :Queen, color: "b")

        board.place_piece([1, 5], piece: :King, color: "w")
        moves = board[1, 5].piece.possible_moves(board)

        expect(moves).to match_array([
          [1, 6], [2, 5], [2, 4], [1, 4], [0, 4], [0, 6]
        ])
      end
    end
  end
end
