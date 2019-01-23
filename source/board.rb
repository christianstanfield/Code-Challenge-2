class Board

  attr_reader :width, :height, :winning_number

  def initialize dimensions
    @width          = dimensions[:width]
    @height         = dimensions[:height]
    @winning_number = dimensions[:winning_number]
  end

  def valid?
    dimensions_valid? && winning_number_valid?
  end

  private

  def dimensions_valid?
    [width, height, winning_number].all? do |value|
      value.is_a?(Integer) && value > 1
    end
  end

  def winning_number_valid?
    winning_number <= [width, height].min
  end
end
