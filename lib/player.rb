class Player

  # class methods
  def self.from_json(player)
    Player.new(color: player["color"])
  end

  attr_accessor :color, :other_color

  def initialize(color:)
    @color = color
    @other_color = @color == "w" ? "b":"w"
  end

  def to_json
    {
      color: @color
    }
  end

  def fetch_instructions
    puts "It's #{full_color}'s turn. Please enter your move/command:"
    begin
      input = gets.chomp
    end while input == ""

    return input
  end

  def full_color
    return "White" if @color.downcase == "w"
    return "Black" if @color.downcase == "b"
  end
end
