require_relative './pieces/pawn.rb'

class Move

  attr_accessor :piece, :from, :to, :takes

  def initialize(piece, from:, to:, takes:)
    @piece = piece
    @from = from
    @to = to
    @takes = takes
  end

  def en_passant?
    @piece.instance_of?(Pawn) and (@to[1] - @from[1]).abs == 2
  end

  def to_s
    "#{from} -> #{to}"
  end

  def reverse(board)
    # first set the moving piece back to where it came from
    @piece.position = from
    board[*from].piece = @piece
    board[*to].piece = nil

    # then if a piece was captured set it back to the position it was at
    # originally (! in case of en passant this is not equal to @to!)
    if @takes != false
      board[*@takes.position].piece = @takes
      board.captured_pieces.delete(@takes)
    end
  end
end
