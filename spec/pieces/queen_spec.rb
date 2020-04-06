require './lib/pieces/knight.rb'
require './lib/board.rb'

RSpec.describe Queen do
  context "when the Queen is the only piece" do
    describe "#possible_moves" do
      it "returns a list of all possible moves for a Queen at the border" do
        board = double("Board")
        square = double("Square")
        allow(board).to receive(:[]).and_return(square)
        # set all the squares in the board as empty squares
        allow(square).to receive(:occupied?).and_return(false)

        queen = Queen.new(position: [0, 4], color: "w")
        moves = queen.possible_moves(board)

        expect(moves).to match_array([
          [0, 5], [0, 6], [0, 7],  # top
          [1, 5], [2, 6], [3, 7],  # top right
          [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4],  # right
          [1, 3], [2, 2], [3, 1], [4, 0],  # bottom right
          [0, 3], [0, 2], [0, 1], [0, 0]   # bottom
        ])
      end

      it "returns a list of all possible moves for a Queen in the middle" do
        board = double("Board")
        square = double("Square")
        allow(board).to receive(:[]).and_return(square)
        # set all the squares in the board as empty squares
        allow(square).to receive(:occupied?).and_return(false)

        queen = Queen.new(position: [4, 4], color: "b")
        moves = queen.possible_moves(board)

        expect(moves).to match_array([
          [4, 5], [4, 6], [4, 7],
          [5, 5], [6, 6], [7, 7],
          [5, 4], [6, 4], [7, 4],
          [5, 3], [6, 2], [7, 1],
          [4, 3], [4, 2], [4, 1], [4, 0],
          [3, 3], [2, 2], [1, 1], [0, 0],
          [3, 4], [2, 4], [1, 4], [0, 4],
          [3, 5], [2, 6], [1, 7]
        ])
      end
    end
  end

  context "when the Queen is not the only piece" do
    describe "#possible_moves" do
      it "returns a list of possible moves" do
        board = Board.new
        board.place_piece([0, 1], piece: :Bishop, color: "w")
        board.place_piece([0, 4], piece: :Bishop, color: "b")
        board.place_piece([2, 6], piece: :Knight, color: "w")
        board.place_piece([3, 2], piece: :Queen, color: "b")
        board.place_piece([3, 6], piece: :Rook, color: "b")
        board.place_piece([4, 5], piece: :Bishop, color: "b")
        board.place_piece([4, 6], piece: :Knight, color: "b")

        board.place_piece([3, 4], piece: :Queen, color: "w")
        moves = board[3, 4].piece.possible_moves(board)

        expect(moves).to match_array([
          [3, 5], [3, 6],
          [4, 5],
          [4, 4], [5, 4], [6, 4], [7, 4],
          [4, 3], [5, 2], [6, 1], [7, 0],
          [3, 3], [3, 2],
          [2, 3], [1, 2],
          [2, 4], [1, 4], [0, 4],
          [2, 5], [1, 6], [0, 7]
        ])
      end
    end
  end
end
