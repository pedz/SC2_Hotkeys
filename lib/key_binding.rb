
class KeyBinding
  # The primary key
  attr_accessor :pri

  # The list of alternatives
  attr_accessor :alt

  # The Attribute this KeyBinding is a value for
  attr_accessor :parent

  # Takes a string such as "a,b,c,d" and creates a biinding with pri
  # equal to "a" and alt equal to [ "b", "c", "d" ]
  def initialize(parent, str = "")
    @parent = parent
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

  def ==(v)
    all.sort == v.all.sort
  end

  def empty?
    all.empty?
  end

  # def freeze
  #   pri.freeze
  #   alt.freeze
  #   self
  # end

  # How a binding should be printed out
  def to_s
    all.join(',')
  end
end
