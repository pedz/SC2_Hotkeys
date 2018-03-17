
class KeyBinding
  # The primary key
  attr_accessor :pri

  # The list of alternatives
  attr_accessor :alt

  # Takes a string such as "a,b,c,d" and creates a biinding with pri
  # equal to "a" and alt equal to [ "b", "c", "d" ]
  def initialize(str = "")
    @pri, *@alt = (str ||= "").split(',')
  end

  # Returns the full list as an array of string
  def all
    if pri
      [ pri ] + alt
    else
      alt
    end
  end

  # How a binding should be printed out
  def to_s
    all.join(',')
  end
end
