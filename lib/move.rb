require_relative './pieces/pawn.rb'

class Move

  attr_accessor :piece, :from, :to, :takes

  def initialize(piece, from:, to:, takes: false)
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
end
