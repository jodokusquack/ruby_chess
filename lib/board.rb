require_relative './square.rb'
require_relative './player.rb'
Dir['./lib/pieces/*.rb'].each { |file| require file }

class Board

  attr_accessor :black_pieces, :white_pieces, :squares, :captured_pieces


  def initialize(squares: nil, captured_pieces: [])
    # create a default value for the squares
    squares_default = (0..7).collect do |i|
      (0..7).collect do |j|
        color = (i+j) % 2 == 0 ? "b" : "w"
        Square.new(color: color)
      end
    end
    @squares = squares || squares_default
    update_pieces
    @captured_pieces = captured_pieces
  end

  def [](col, row)
    @squares[col][row]
  end

  def to_s
    repr = "\n"
    7.downto(0) do |row|
      repr << " #{row + 1} | "
      0.upto(7) do |col|
        repr << self[col, row].to_s + " "
      end
      repr << "\n"
    end
    repr << "    ---------------- \n"
    repr << "     a b c d e f g h \n"
    return repr
  end

  def place_piece(position, piece:, color:)
    return false if position.max > 7 or position.min < 0

    new_piece = Kernel.const_get(piece).new(position: position, color: color)

    self[*position].piece = new_piece
    update_pieces

    return new_piece
  end

  def move_piece(from , to)
    piece = self[*from].piece

    return false if piece.nil?
    return false if !piece.possible_moves(self).include?(to)
    # return false if in check afterwards

    # first copy the piece that is at "to"
    old_piece = self[*to].piece

    # then copy over the piece to move (from "from" to "to")
    self[*to].piece = piece

    # update the position of the moved piece
    piece.position = to

    #delete the old piece
    self[*from].piece = nil

    # add the captured piece to the captured_pieces
    unless old_piece.nil?
      old_piece.position = [nil, nil]
      @captured_pieces << old_piece
    end

    return old_piece || true
  end


  private

  def update_pieces
    @white_pieces = []
    @black_pieces = []
    @squares.flatten.each do |square|
      if square.occupied?
        if square.piece.color == "w"
          @white_pieces << square.piece
        else
          @black_pieces << square.piece
        end
      end
    end
  end

end

b = Board.new
b.place_piece([4, 4], piece: :Rook , color: "b")
puts b
puts "Black:"
puts b.black_pieces
puts "White:"
puts b.white_pieces
