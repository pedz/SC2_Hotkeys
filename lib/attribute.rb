
require_relative 'key_binding'

class Attribute
  # The name of the Attribute
  attr_accessor :name

  # The value of the Attribute
  attr_accessor :value
  
  # References the Section this Attribute is a part of
  attr_accessor :parent

  def initialize(parent, name, value)
    @parent, @name, @value = parent, name, KeyBinding.new(self, value)
  end

  def ==(v)
    # Do not check the names... just the values
    value == v.value
  end

  def path
    "#{parent.path}:#{name}"
  end

  def to_s
    "#{@name}=#{@value}"
  end
end
