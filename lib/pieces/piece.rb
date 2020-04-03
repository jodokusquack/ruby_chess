class Piece

  attr_reader :position, :row, :col

  def initialize(position:)
    # position is an array of [col, row], which each can be between 0..7
    @position = position
    @col = @position[0]
    @row = @position[1]
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
end
