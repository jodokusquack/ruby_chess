class Player

  attr_accessor :color

  def initialize( color: , has_castled: false)
    @color = color
    @has_castled = has_castled
  end

  def castled?
    @has_castled
  end

  def fetch_instructions(board)
    puts "It's #{full_color}'s turn. Please enter your move/command:"
    begin
      input = gets.chomp
    end while input == ""

    return input
  end

  private

  def full_color
    return "White" if @color.downcase == "w"
    return "Black" if @color.downcase == "b"
  end
end
