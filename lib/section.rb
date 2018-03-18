
require_relative "attribute"

# Represents the Settings, Hotkeys, or Commands sectio of a Hotkey
# file.
class Section
  # The name of the Section
  attr_accessor :name

  # A hash by Attribute name of Attribute objects.
  attr_accessor :attributes

  # Points to the containing HotkeyFile
  attr_accessor :parent

  NAME_REGEXP = Regexp.new('\A\[(?<name>.*)\]')
  BLANK_REGEXP = Regexp.new('\A\s*\z')
  ATTR_REGEXP = Regexp.new('\A(?<name>.+)=(?<value>.*)\z')

  # Returns nil if no section name is found.  Otherwise returns an
  # array of two: name, attributes
  def self.parse(parent, io)
    # scan until we get to the section heading
    md = nil
    loop do
      return if io.eof?
      break if md = NAME_REGEXP.match(io.current_line)
      io.gets
    end

    name = md[:name]
    attrs = {}
    me = new(parent, name, attrs)

    loop do
      break if io.eof?
      io.gets
      next if BLANK_REGEXP.match(io.current_line)
      break unless md = ATTR_REGEXP.match(io.current_line)
      name = md[:name]
      value = md[:value]
      attrs[name] = Attribute.new(me, name, value)
    end
    me
  end
  
  def initialize(parent, name, attributes)
    @parent, @name, @attributes = parent, name, attributes
  end

  def to_s
    ([ "[#{@name}]" ] + @attributes.map(&:to_s).sort).join("\n")
  end

  def all_attributes
    @attributes.each_value
  end

  def map_name
    @parent.map_name
  end

  def path
    "#{@parent.path}:#{name}"
  end
end
