class TurnTracker

  attr_accessor :current

  def initialize(current: "w")
    @current = current
  end

  def next
    if @current == "w"
      @current = "b"
    else
      @current = "w"
    end

    @current
  end
end
