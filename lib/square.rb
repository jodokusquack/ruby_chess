class Square

  attr_accessor :color, :piece

  def initialize(color:, piece: nil)
    # each square has a color ("w" or "b") and an optional piece on it
    @color = color
    @piece = piece
  end

  def occupied?
    !@piece.nil?
  end

  def to_s
    # either return piece.to_s or a square with color
    if occupied?
      @piece.to_s
    elsif @color == "w"
      "■"
    else
      "□"
    end
  end
end
