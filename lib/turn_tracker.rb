class TurnTracker

  # class methods
  def self.from_json(tracker)
    players = tracker["players"].map { |p| Player.from_json(p) }
    current_color = Player.from_json(tracker["current"]).color

    TurnTracker.new(players: players, current_color: current_color)
  end

  # instance methods
  attr_accessor :current, :players

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

  def to_json
    players = @players.map { |p| p.to_json }

    {
      current: @current.to_json,
      players: players
    }
  end
end
