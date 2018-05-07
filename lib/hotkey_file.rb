
require_relative "my_io"
require_relative "section"

# Represents a full SC2 Hotkey file.
class HotkeyFile
  # The basename of the hotkey file.
  attr_accessor :name
  
  # A hash with the name of the section as the key and the value a
  # Section.
  attr_accessor :sections

  def self.parse(io)
    me = new(File.basename(io.path))
    io = MyIO.new(io) unless io.is_a?(MyIO)
    loop do
      break unless section = Section.parse(me, io)
      me.sections[section.name] = section
    end
    me
  end
  
  # io is an IO object.
  def initialize(name)
    @name = name
    @sections = {}
  end

  def all_attributes
    Enumerator.new do |y|
      @sections.each do |key, value|
        value.all_attributes.each do |attr|
          y << attr
        end
      end
    end
  end

  def to_s
    [ "Settings", "Hotkeys", "Commands" ].map { |section| @sections[section].to_s }.join("\n\n")
  end

  def path
    "#{@name}"
  end

  def map_name
    @map_name ||= @name.sub(/\.[^.]+\z/, '')
  end

  # True if the keymap file has AllowSetConflicts set to 1
  def allow_conflicts
    ((s = self.sections["Settings"]) &&
     (a = s.attributes["AllowSetConflicts"]) &&
     (a.value.pri == '1'))
  end
end

if $0 == __FILE__
  puts HotkeyFile.parse($<).to_s
end
