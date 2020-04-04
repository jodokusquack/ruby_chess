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

  describe "#move" do
    it "moves a piece from one position to another" do
      board = Board.new
      board.place_piece([4, 4], piece: :Rook, color: "w")

      board.move_piece([4, 4], [4, 7])

      expect(board[4, 7].piece).to be_instance_of(Rook)
      expect(board[4, 7].piece.color).to be "w"
      expect(board[4, 7].piece.position).to be [4, 7]
      expect(board[4, 4].piece).to be_nil
    end

    xit "returns a captured piece" do
      board = Board.new
      board.place_piece([3, 3], piece: :Rook, color: "b")
      # piece for capturing
      board.place_piece([7, 3], piece: :Rook, color: "w")

      captured_piece = board.move_piece([3, 3], [7, 3])

      moved_piece = board[7, 3]

      expect(captured_piece).to be_instance_of(Rook)
      expect(capture_piece.color).to eq "w"
      expect(captured_piece.position).to eq [nil, nil]

      expect(moved_piece).to be_instance_of(Rook)
      expect(moved_piece.color).to eq "b"
      expect(moved_piece.position).to eq [7, 3]
    end

    xit "adds a captured piece to the captured pieces" do
      board = Board.new
      board.place_piece([0, 7], piece: :Rook, color: "b")
      # piece for capturing
      board.place_piece([5, 7], piece: :Rook, color: "w")

      expect { board.move_piece([0, 7], [5, 7]) }.to change {
        board.captured_pieces.length }.by(1)
    end

    xit "doesn't change the captured pieces if no piece was captured" do
      board = Board.new
      board.place_piece([0, 7], piece: :Rook, color: "b")

      expect { board.move_piece([0, 7], [0, 0]) }.to_not change {
        board.captured_pieces.length }
    end

    xit "returns false if the end position is out of bounds" do
      board = Board.new
      board.place_piece([2, 5], piece: :Rook , color: "w")

      result = board.move_piece([2, 5], [2, 9])

      expect(result).to eq false
    end

    xit "returns false if the end position is not a legal move" do
      board = Board.new
      board.place_piece([2, 5], piece: :Rook , color: "b")

      result = board.move_piece([2, 5], [3, 2])

      expect(result).to eq false
    end

    xit "returns false if a piece is in the way" do
      board = Board.new
      board.place_piece([2, 5], piece: :Rook, color: "w")
      # piece in the way
      board.place_piece([2, 6], piece: :Rook, color: "w")

      result = board.move_piece([2, 5], [2, 7])

      expect(result).to eq false
    end

    xit "doesn't move the piece if the move isn't valid" do
      board = Board.new
      board.place_piece([2, 5], piece: :Rook, color: "w")
      # piece in the way
      board.place_piece([2, 6], piece: :Rook, color: "w")

      result = board.move_piece([2, 5], [2, 7])

      expect(result).to eq false
      expect(board[2, 5].piece.color).to eq "w"
      expect(board[2, 5].piece.position).to eq [2, 5]
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

    xit "can castle long"

    xit "can caste short"

    xit "doesn't allow castleing over check"
  end
end
