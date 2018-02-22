#!/usr/bin/env ruby

# All these could be one class but lets split them up for now.

# Denotes the mode the game is in
class Mode
  # The name of the mode -- Campaign, Verses, Co-Op, Arcade
  attr_accessor :name
  # The areas within the mode -- Terran, Terran Story, ...
  attr_accessor :areas
  # To be consistent, the class has a parent which will always be
  # nil.
  attr_accessor :parent

  def initialize(name)
    @name = name
    @parent = nil
    @areas = []
  end

  def push(area)
    area.parent = self
    @areas.push(area)
  end
end

# When in a mode and Options are entered and then Hotkeys, the screen
# comes up with four buttons on the left in Verses mode and 7 buttons
# in Campaign mode such as Protoss, Protoss Story, ... Global.  I call
# these "Areas"
class Area
  # The name of the area
  attr_accessor :name
  # The (always two?) subareas within the area of Units and
  # Structures.
  attr_accessor :sub_areas
  # The parent Mode for this Area
  attr_accessor :parent

  def initialize(name)
    @name = name
    @parent = nil
    @sub_areas = []
  end

  def push(sub_area)
    sub_area.parent = self
    @sub_areas.push(sub_area)
  end
end

# Within an area there is usually two partitions -- one for Units and
# the other for Structures.  This allows more than two and with
# different names.
#
# Within a sub area, there can be units and structures.  For now, both
# of these will be called items.
class SubArea
  # The name of the area
  attr_accessor :name
  # The (always two?) subareas within the area of Units and
  # Structures.
  attr_accessor :items
  # The parent Area for this SubArea
  attr_accessor :parent

  def initialize(name)
    @name = name
    @parent = nil
    @items = []
  end

  def push(item)
    item.parent = self
    @items.push(item)
  end
end

# An Item is a unit or a structure.
class Item
  # The name of the area
  attr_accessor :name
  # The (always two?) subareas within the area of Units and
  # Structures.
  attr_accessor :cards
  # The parent SubArea for this Item
  attr_accessor :parent

  def initialize(name)
    @name = name
    @parent = nil
    @cards = []
  end

  def push(card)
    card.parent = self
    @cards.push(card)
  end
end

# With the UI, when an item is selected such as the SVC, on the right
# side of the screen game cards are shown.  The different cards are
# usually different states the item can be in or the UI controlling
# the item.  But there are cards, especially in Campaign mode with a
# Story area where multiple game cards are displayed and I don't know
# yet where they are used.
#
# The game card always has three rows and five columns of commands.
# But I think I'm going to keep them as a list with the command
# specifying the character used to select the command and the position
# of the command within the game card.
class Card
  # The name of the card
  attr_accessor :name
  # The card has commands in it
  attr_accessor :commands
  # The parent Item for this Card
  attr_accessor :parent

  def initialize(name)
    @name = name
    @parent = nil
    @commands = []
  end

  def push(command)
    command.parent = self
    @commands.push(command)
  end
end

# Finally something interesting.  For now, a command has the row and
# column position in its parent card and the character assigned to
# it.
class Command
  # The row the command is on in its parent card
  attr_accessor :row
  # The column the command is in on its parent card
  attr_accessor :col
  # The character to activate the command
  attr_accessor :char

  def initialize(row, col, char)
    @row = row
    @col = col
    @char = char
  end
end
