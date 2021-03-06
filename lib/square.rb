class Square

  # class methods
  def self.from_json(square)
    if square["piece"].nil?
      piece = nil
    else
      piece = Piece.from_json(square["piece"])
    end

    new(color: square["color"], piece: piece)
  end

  # instance methods
  attr_accessor :color, :piece

  def initialize(color:, piece: nil)
    # each square has a color ("w" or "b") and an optional piece on it
    @color = color
    @piece = piece
  end

  def occupied?
    !@piece.nil?
  end

  def to_json
    piece = nil
    piece = @piece.to_json if !@piece.nil?

    {
      color: @color,
      piece: piece
    }
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
