require './lib/pieces/pawn.rb'
require './lib/board.rb'

RSpec.describe Pawn do
  describe "#possible_moves" do
    context "when the Pawn is white" do
      context "and on the home row" do
        it "returns a list of all possible moves" do
          board = double("Board")
          square = double("Square")
          allow(board).to receive(:[]).and_return(square)
          # set all the squares in the board as empty squares
          allow(square).to receive(:occupied?).and_return(false)

          pawn = Pawn.new(position: [4, 1], color: "w")
          moves = pawn.possible_moves(board)

          expect(moves).to match_array([
            [4, 2], [4, 3]
          ])
        end
      end

      context "and not on the home row" do
        it "returns a list of all possible moves" do
          board = double("Board")
          square = double("Square")
          allow(board).to receive(:[]).and_return(square)
          # set all the squares in the board as empty squares
          allow(square).to receive(:occupied?).and_return(false)

          pawn = Pawn.new(position: [7, 6], color: "w")
          moves = pawn.possible_moves(board)

          expect(moves).to match_array([
            [7, 7]
          ])
        end
      end
    end

    context "when the Pawn is black" do
      context "and on the home row" do
        it "returns a list of all possible moves" do
          board = double("Board")
          square = double("Square")
          allow(board).to receive(:[]).and_return(square)
          # set all the squares in the board as empty squares
          allow(square).to receive(:occupied?).and_return(false)

          pawn = Pawn.new(position: [0, 6], color: "b")
          moves = pawn.possible_moves(board)

          expect(moves).to match_array([
            [0, 5], [0, 4]
          ])
        end
      end

      context "and not on the home row" do
        it "returns a list of all possible moves" do
          board = double("Board")
          square = double("Square")
          allow(board).to receive(:[]).and_return(square)
          # set all the squares in the board as empty squares
          allow(square).to receive(:occupied?).and_return(false)

          pawn = Pawn.new(position: [2, 5], color: "b")
          moves = pawn.possible_moves(board)

          expect(moves).to match_array([
            [2, 4]
          ])
        end
      end
    end

    context "when a white Pawn is not the only piece" do
      it "returns a list of possible moves" do
        board = Board.new
        board.place_piece([5, 2], piece: :Pawn, color: "w")
        board.place_piece([5, 3], piece: :Pawn, color: "b")
        board.place_piece([6, 3], piece: :Rook, color: "w")
        board.place_piece([7, 3], piece: :Pawn, color: "b")

        board.place_piece([6, 2], piece: :Pawn, color: "w")
        moves = board[6, 2].piece.possible_moves(board)

        expect(moves).to match_array([
          [5, 3], [7, 3]
        ])
      end

      it "returns a list of possible moves" do
        board = Board.new
        board.place_piece([3, 5], piece: :Knight, color: "w")

        board.place_piece([4, 6], piece: :Pawn, color: "b")
        moves = board[4, 6].piece.possible_moves(board)

        expect(moves).to match_array([
          [4, 5], [4, 4], [3, 5]
        ])
      end
    end

    context "when a pawn has just moved two squares forward" do
      it "can take the pawn en passant" do
        board = Board.new
        board.place_piece([5, 2], piece: :Rook, color: "w")
        board.place_piece([3, 1], piece: :Pawn, color: "w")
        board.move([3, 1], [3, 3])

        board.place_piece([4, 3], piece: :Pawn, color: "b")
        moves = board[4, 3].piece.possible_moves(board)

        expect(moves).to match_array([
          [4, 2], [5, 2], [3, 2]
        ])
      end
    end
  end
end
