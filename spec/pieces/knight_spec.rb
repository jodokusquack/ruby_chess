require './lib/pieces/knight.rb'
require './lib/board.rb'

RSpec.describe Knight do
  context "when the Knight is the only piece" do
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

        knight = Knight.new(position: [6, 0], color: "w")
        moves = knight.possible_moves(board)

        expect(moves).to match_array([
          [7, 2], [5, 2], [4, 1]
        ])
      end

      it "returns a list of all possible moves for a knight in the middle" do
        board = double("Board")
        square = double("Square")
        allow(board).to receive(:[]).and_return(square)
        # set all the squares in the board as empty squares
        allow(square).to receive(:occupied?).and_return(false)

        knight = Knight.new(position: [4, 4], color: "b")
        moves = knight.possible_moves(board)

        expect(moves).to match_array([
          [5, 6], [6, 5], [6, 3], [5, 2], [3, 2], [2, 3], [2, 5], [3, 6]
        ])
      end
    end
  end

  context "when the Knight is not the only piece" do
    describe "#possible_moves" do
      it "returns a list of possible moves" do
        board = Board.new
        board.place_piece([2, 3], piece: :Knight, color: "w")
        board.place_piece([3, 2], piece: :Bishop, color: "w")
        board.place_piece([4, 5], piece: :Rook, color: "b")
        board.place_piece([5, 5], piece: :Rook, color: "w")
        board.place_piece([5, 6], piece: :Rook, color: "b")

        board.place_piece([4, 4], piece: :Knight, color: "w")
        moves = board[4, 4].piece.possible_moves(board)

        expect(moves).to match_array([
          [5, 6], [6, 5], [6, 3], [5, 2], [2, 5], [3, 6]
        ])
      end
    end
  end
end
