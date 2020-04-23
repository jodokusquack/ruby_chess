class Piece

  attr_reader :position, :row, :col, :color
  attr_accessor :has_moved

  def initialize(position:, color:, has_moved: false)
    # position is an array of [col, row], which each can be between 0..7
    @position = position
    @col = @position[0]
    @row = @position[1]
    @color = color
    @has_moved = has_moved
  end

  def to_json
    {
      type: self.class.to_s,
      pos: @position,
      color: @color,
      has_moved: @has_moved
    }
  end

  def position=(arr)
    @position = arr
    @col = arr[0]
    @row = arr[1]
  end

  def col=(col_number)
    @col = col_number
    @position[0] = col_number
  end

  def row=(row_number)
    @row = row_number
    @position[1] = row_number
  end

  def ==(other)
    if other.kind_of?(Piece)
      self.position == other.position and self.color == other.color
    else
      false
    end
  end

  def legal_moves(board)
    reachable = possible_moves(board)
    # if the color of the piece isn't in check, all reachable squares are
    # legal
    return reachable if !board.check?(@color)

    # otherwise check every possible move, for a possible check after it
    legal = []
    reachable.each do |pos|
      # do the move
      board.move_piece_to_possible(@position, pos)
      # check for check and if there is no check, add the move to the
      # legal moves
      if !board.check?(@color)
        legal << pos
      end
      # lastly take back the turn
      board.take_back_turn
    end

    return legal
  end
end
