#!/usr/bin/env ruby

# File reads defaults.SC2Hotkeys to set up the default hotkey
# settings.  This will also know the special cases that I introduced
# while I was creating it.  Really... this is the first stab at
# parsing the hotkey file

# The file is broken into sections.  The known sections at this time
# are Settings, Hotkeys, and Commands.
class Section

  # The name of the section
  attr_accessor :name
  # The entries within the section
  attr_accessor :entries
  
  def initialize(name)
    @name = name
    @entries = []
  end

  def push(item)
    entries.push(item)
  end

  def to_s
    ( [ "[#{@name}]" ] + @entries.map(&:to_s) ).join("\n")
  end
end

class Entry
  def initialize(line)
    @orig = line
    # should always be an = it seems
    @left, @right = line.split('=')
    # an undefined setting has no right side
    @right = "" unless @right
    @alts = @right.split(',')
    @prim = @alts.shift
    temp = @left.split('/')
    if temp.length == 1
      @key = temp[0]
      @subkey = nil
    else
      @key = temp[1]
      @subkey = temp[0]
    end
  end

  def to_s
    if @subkey
      base = "#{@subkey}/#{@key}="
    else
      base = "#{@key}="
    end
    base + ( [ @prim ] + @alts).join(',')
  end
end

class HotkeyFile
  def self.parse(io)
    sections = []
    current_section = nil
    io.each_line do |line|
      next if /\A\s*\Z/.match(line)
      line.chomp!
      if md = /\A\[(?<name>.*)\]\z/.match(line)
        current_section = Section.new(md[:name])
        sections.push(current_section)
        next
      end
      next unless current_section
      current_section.push(Entry.new(line))
    end
    sections
  end
end

puts HotkeyFile.parse(File.open("defaults.SC2Hotkeys", "r")).map(&:to_s).join("\n\n")
