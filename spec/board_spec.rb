require './lib/board.rb'

RSpec.describe Board do

  describe "#place_piece" do
    it "creates a new piece and returns it" do
      board = Board.new
      compare_rook = Rook.new(position: [6, 2], color: "b")

      result = board.place_piece([6, 2], piece: :Rook, color: "b")

      expect(result).to be_instance_of(Rook)
      expect(result.position).to eq [6, 2]
      expect(result.color).to eq "b"
      expect(board.black_pieces).to match_array([compare_rook])
    end

    it "places the piece on the board" do
      board = Board.new
      compare_rook = Rook.new(position: [2, 6], color: "w")

      expect { board.place_piece([2, 6], piece: :Rook, color: "w") }.to change(
        board[2, 6], :piece).from(nil).to(compare_rook)
    end

    it "returns false if the position is out of bounds" do
      board = Board.new

      result = board.place_piece([8,8], piece: :Rook, color: "b")

      expect(result).to eq false
    end

    it "doesn't place a new piece if the position is out of bounds" do
      board = Board.new

      expect do
        board.place_piece([-1, 5], piece: :Rook, color: "w")
      end.to_not change { board.white_pieces }
    end
  end

  describe "#move_piece" do
    it "moves a piece from one position to another" do
      board = Board.new
      board.place_piece([4, 4], piece: :Rook, color: "w")

      board.move_piece([4, 4], [4, 7])

      expect(board[4, 7].piece).to be_instance_of(Rook)
      expect(board[4, 7].piece.color).to eq "w"
      expect(board[4, 7].piece.position).to eq [4, 7]
      expect(board[4, 4].piece).to be_nil
    end

    it "returns a captured piece" do
      board = Board.new
      board.place_piece([3, 3], piece: :Rook, color: "b")
      # piece for capturing
      board.place_piece([7, 3], piece: :Rook, color: "w")

      captured_piece = board.move_piece([3, 3], [7, 3])

      moved_piece = board[7, 3].piece

      expect(captured_piece).to be_instance_of(Rook)
      expect(captured_piece.color).to eq "w"

      expect(moved_piece).to be_instance_of(Rook)
      expect(moved_piece.color).to eq "b"
      expect(moved_piece.position).to eq [7, 3]
    end

    it "adds a captured piece to the captured pieces" do
      board = Board.new
      board.place_piece([0, 7], piece: :Rook, color: "b")
      # piece for capturing
      board.place_piece([5, 7], piece: :Rook, color: "w")

      expect { board.move_piece([0, 7], [5, 7]) }.to change {
        board.captured_pieces.length }.by(1)
    end

    it "updates the pieces-array" do
      board = Board.new
      board.place_piece([4, 4], piece: :Rook, color: "b")
      board.place_piece([0, 7], piece: :Rook, color: "b")
      # piece for capturing
      board.place_piece([5, 7], piece: :Rook, color: "w")

      expect { board.move_piece([5, 7], [0, 7]) }.to change {
        board.black_pieces.length }.by(-1)
    end

    it "doesn't change the captured pieces if no piece was captured" do
      board = Board.new
      board.place_piece([0, 7], piece: :Rook, color: "b")

      expect { board.move_piece([0, 7], [0, 0]) }.to_not change {
        board.captured_pieces.length }
      expect { board.move_piece([0, 7], [0, 0]) }.to_not change {
        board.black_pieces }
    end

    it "returns false if there is no piece to move" do
      board = Board.new

      result = board.move_piece([0, 0], [4, 5])

      expect(result).to eq false
    end

    it "returns false if the end position is out of bounds" do
      board = Board.new
      board.place_piece([2, 5], piece: :Rook , color: "w")

      result = board.move_piece([2, 5], [2, 9])

      expect(result).to eq false
    end

    it "returns false if the end position is not a legal move" do
      board = Board.new
      board.place_piece([2, 5], piece: :Rook , color: "b")

      result = board.move_piece([2, 5], [3, 2])

      expect(result).to eq false
    end

    it "returns false if a piece is in the way" do
      board = Board.new
      board.place_piece([2, 5], piece: :Rook, color: "w")
      # piece in the way
      board.place_piece([2, 6], piece: :Rook, color: "w")

      result = board.move_piece([2, 5], [2, 7])

      expect(result).to eq false
    end

    it "doesn't move the piece if the move isn't valid" do
      board = Board.new
      board.place_piece([2, 5], piece: :Rook, color: "w")
      # piece in the way
      board.place_piece([2, 6], piece: :Rook, color: "w")

      result = board.move_piece([2, 5], [2, 7])

      expect(result).to eq false
      expect(board[2, 5].piece.color).to eq "w"
      expect(board[2, 5].piece.position).to eq [2, 5]
    end

    it "can take a pawn en passant" do
      board = Board.new
      board.place_piece([5, 1], piece: :Pawn, color: "w")
      board.place_piece([4, 3], piece: :Pawn, color: "b")
      board.move_piece([5, 1], [5, 3])

      captured = board.move_piece([4, 3], [5, 2])

      expect(captured).to be_instance_of(Pawn)
      expect(captured.color).to eq "w"
      expect(board[5, 3].piece).to be_nil
      expect(board[5, 2].piece.color).to eq "b"
      expect(board.captured_pieces.length).to be 1
      expect(board.captured_pieces[0].color).to eq "w"
    end

    it "adds the move to the array of previous moves" do
      board = Board.new
      board.place_piece([4, 4], piece: :Queen, color: "b")

      expect { board.move_piece([4, 4], [4, 5]) }.to change {
        board.prev_moves.length }.by(1)
    end

    xit "doesn't allow to move into check" do
      board = Board.new
      board.place_piece([4, 3], piece: :Rook, color: "w")
      board.place_piece([3, 6], piece: :King, color: "b")

      result = board.move_piece([3, 6], [4, 6])

      expect(result).to eq false
      expect(board[3, 6].piece).to be_instance_of(King)
      expect(board[3, 6].piece.color).to be "b"
      expect(board[3, 6].piece.position).to be [3, 6]
    end

    xit "returns false if the King doesn't move out of check" do
      board = Board.new
      board.place_piece([4, 3], piece: :Rook, color: "w")
      board.place_piece([4, 6], piece: :King, color: "b")

      result = board.move_piece([4, 6], [4, 7])

      expect(result).to eq false
      expect(board[4, 6].piece).to be_instance_of(King)
      expect(board[4, 6].piece.color).to be "b"
      expect(board[4, 6].piece.position).to be [4, 6]
    end

    # these may go into another method
    it "can castle long"

    it "can caste short"

    it "doesn't allow castleing over check"


    it "asks for a pawn to be promoted when it reaches the end row"
  end

  describe "#check?" do
    it "can tell if white is in check" do
      board = Board.new
      board.place_piece([3, 1], piece: :King, color: "w")
      board.place_piece([3, 2], piece: :Pawn, color: "w")
      board.place_piece([2, 2], piece: :Pawn, color: "b")
      board.place_piece([6, 4], piece: :Bishop, color: "b")

      check = board.check?("w")

      expect(check).to eq true
    end

    it "can tell if white is not in check" do
      board = Board.new
      board.place_piece([3, 1], piece: :King, color: "w")
      board.place_piece([3, 2], piece: :Pawn, color: "w")
      board.place_piece([4, 2], piece: :Knight, color: "w")
      board.place_piece([3, 3], piece: :Rook, color: "b")
      board.place_piece([6, 4], piece: :Bishop, color: "b")

      check = board.check?("w")

      expect(check).to eq false
    end

    it "can tell if black is in check" do
      board = Board.new
      board.place_piece([4, 7], piece: :Knight, color: "w")
      board.place_piece([4, 6], piece: :Queen, color: "b")
      board.place_piece([4, 5], piece: :Rook, color: "b")
      board.place_piece([5, 5], piece: :King, color: "b")

      check = board.check?("b")

      expect(check).to eq true
    end

    it "can tell if black is not in check" do
      board = Board.new
      board.place_piece([4, 7], piece: :Queen, color: "w")
      board.place_piece([4, 6], piece: :Queen, color: "b")
      board.place_piece([4, 5], piece: :Rook, color: "b")
      board.place_piece([5, 5], piece: :King, color: "b")

      check = board.check?("w")

      expect(check).to eq false
    end
  end

  describe "#take_back_turn" do
    it "can take back a simple move" do
      board = Board.new
      board.place_piece([4, 4], piece: :Rook, color: "b")
      board.move_piece([4, 4], [3, 4])

      board.take_back_turn

      expect(board[4, 4].piece.position).to eq [4, 4]
      expect(board[3, 4].piece).to eq nil
    end

    it "can take back a turn where a piece was captured" do
      board = Board.new
      board.place_piece([4, 4], piece: :Rook, color: "b")
      board.place_piece([3, 4], piece: :Rook, color: "w")
      board.move_piece([4, 4], [3, 4])

      expect { board.take_back_turn }.to change{ board[3, 4].piece }
      expect(board[4, 4].piece.position).to eq [4, 4]
      expect(board[4, 4].piece.color).to eq "b"
      expect(board[3, 4].piece.position).to eq [3, 4]
      expect(board[3, 4].piece.color).to eq "w"
    end

    it "updates the pieces after taking back a turn" do
      board = Board.new
      board.place_piece([2, 7], piece: :King, color: "w")
      board.place_piece([2, 6], piece: :Queen, color: "b")
      board.move_piece([2, 7], [2, 6])
      expect(board.check?("w")).to eq false

      expect { board.take_back_turn }.to change {
        board.black_pieces.length }.by(1)
      expect(board.captured_pieces).to be_empty
    end

    it "doesn't mess with en passant" do
      board = Board.new
      board.place_piece([0, 1], piece: :Pawn, color: "w")
      board.place_piece([1, 3], piece: :Pawn, color: "b")
      board.move_piece([0, 1], [0, 3])
      board.move_piece([1, 3], [0, 2])

      expect { board.take_back_turn }.to change {
        board.captured_pieces.length }.by(-1)
      expect(board[1, 3].piece.possible_moves(board)).to match_array([
        [1, 2], [0, 2]
      ])
    end
  end
end
