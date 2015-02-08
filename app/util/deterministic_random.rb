# This is a 'random' number generator that returns deterministic numbers.
# Use this in your test code instead of the normal random number service.

class DeterministicRandom

  def initialize default = 0
    @default = default
    @numbers = []
  end

  def next_number number
    next_numbers number
  end

  def next_numbers *numbers
    @numbers = numbers
  end

  def reset
    @numbers = []
  end

  def rand limit = nil
    @numbers.shift || @default
  end

end
