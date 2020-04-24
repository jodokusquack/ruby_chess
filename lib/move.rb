require_relative './pieces/pawn.rb'

class Move

  # class methods
  def self.from_json(move)
    if move["piece"].is_a?(String)
      piece = move["piece"]
    else
      piece = Piece.from_json(move["piece"])
    end
    from = move["from"]
    to = move["to"]
    castle = move["castle"]

    if move["takes"] == false
      takes = move["takes"]
    else
      takes = Piece.from_json(move["takes"])
    end

    Move.new(piece, from: from, to: to, takes: takes, castle: castle)
  end

  N_TO_L = {
    0 => "a",
    1 => "b",
    2 => "c",
    3 => "d",
    4 => "e",
    5 => "f",
    6 => "g",
    7 => "h"
  }

  # instance methods
  attr_accessor :piece, :from, :to, :takes, :castle

  def initialize(piece, from:, to:, takes:, castle: false)
    @piece = piece
    @from = from
    @to = to
    @takes = takes
    @castle = castle
  end

  def to_json
    # @piece is usually a piece but for the first move it is a String
    # with the content "New Game"
    piece = @piece.is_a?(String) ? @piece : @piece.to_json

    # @takes can be false or an instance of a piece
    takes = @takes ? @takes.to_json : @takes

    {
      piece: piece,
      from: @from,
      to: @to,
      takes: takes,
      castle: @castle
    }
  end

  def en_passant?
    @piece.instance_of?(Pawn) and (@to[1] - @from[1]).abs == 2
  end

  def to_s
    if @piece == "New Game"
      ""
    elsif takes != false
      "#{N_TO_L[from[0]]}#{from[1]+1} takes #{N_TO_L[to[0]]}#{to[1]+1}"
    else
      "#{N_TO_L[from[0]]}#{from[1]+1} -> #{N_TO_L[to[0]]}#{to[1]+1}"
    end
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
