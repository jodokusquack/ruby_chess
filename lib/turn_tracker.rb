class TurnTracker

  attr_accessor :current

  def initialize(players:, current_color: "w")
    @players = players
    @current = @players.find { |p| p.color == current_color }
  end

  def next
    if @current.color == "w"
      @current = @players.find { |p| p.color == "b" }
    else
      @current = @players.find { |p| p.color == "w" }
    end

    @current
  end
end
