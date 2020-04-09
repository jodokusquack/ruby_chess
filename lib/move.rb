require_relative './pieces/pawn.rb'

class Move

  attr_accessor :piece, :from, :to

  def initialize(piece, from:, to:)
    @piece = piece
    @from = from
    @to = to
  end

  def en_passant?
    distance = (@to[1] - @from[1]).abs
    @piece.instance_of?(Pawn) and distance == 2
  end

  def to_s
    "#{from} -> #{to}"
  end
end
