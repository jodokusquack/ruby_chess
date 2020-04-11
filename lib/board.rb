require_relative './square.rb'
require_relative './player.rb'
require_relative './move.rb'
Dir['./lib/pieces/*.rb'].each { |file| require file }

class Board

  attr_accessor :black_pieces, :white_pieces, :squares, :captured_pieces, :prev_moves


  def initialize(squares: nil, captured_pieces: [], prev_moves: [], current_player: "w")
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
    @prev_moves = prev_moves
    @current_player = current_player
  end

  def [](col, row)
    return nil if col < 0 or col > 7
    return nil if row < 0 or row > 7
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
    # assume that no piece will be taken
    takes = false

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

    # if the last piece from the last move can be captured by en passant
    # and the current piece is a Pawn, check if this was the case
    if piece.instance_of?(Pawn) and last_move.en_passant?
      other_position = last_move.to
      if (to[1] - other_position[1]).abs == 1 and to[0] == other_position[0]
        old_piece = self[*other_position].piece
        self[*other_position].piece = nil
      end
    end

    # add the captured piece to the captured_pieces
    unless old_piece.nil?
      old_piece.position = [nil, nil]
      @captured_pieces << old_piece
      # set takes to true if a piece was captured
      takes = true
    end

    prev_moves << Move.new(piece, from: from, to: to, takes: takes)
    update_pieces

    return old_piece || true
  end

  def last_move
    prev_moves[-1] or Move.new("New Game", from:[], to:[])
  end

  def print_moves
    prev_moves.reverse.each do |move|
      puts move
    end
  end

  def check?(color)
    if color == "w"
      white_in_check?
    else
      black_in_check?
    end
  end

  def white_in_checkmate?
    # should be true if all white_pieces have no legal_moves
  end

  private

  def white_in_check?
    white_king = @white_pieces.find { |piece| piece.instance_of?(King) }

    return false if white_king.nil?

    check = @black_pieces.find do |piece|
      piece.possible_moves(self).include? white_king.position
    end

    return !!check
  end

  def black_in_check?
    black_king = @black_pieces.find { |piece| piece.instance_of?(King) }

    return false if black_king.nil?

    check = @white_pieces.find do |piece|
      piece.possible_moves(self).include? black_king.position
    end

    return !!check
  end

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
p b[1, 9]
