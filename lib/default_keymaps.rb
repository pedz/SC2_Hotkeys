
require 'singleton'

class DefaultKeymaps
  include Singleton

  attr_reader :global_maps, :verses_maps, :campaign_maps, :co_op_maps

  def initialize
    @global_maps = read_set("Global", [ "Hotkeys" ])
    @verses_maps = read_set("Verses", [ "Commands" ])
    @campaign_maps = read_set("Campaign", [ "Commands" ])
    @co_op_maps = read_set("CoOp", [ "Commands" ])
    # puts "global size #{@global_maps.size}"
    # puts "verses size #{@verses_maps.size}"
    # puts "campaign size #{@campaign_maps.size}"
    # puts "co_op size #{@co_op_maps.size}"
  end

  def commands
    COMMANDS.each do |name|
      yield @global_maps[name]
    end
  end

  def independent
    INDEPENDENT.each do |name|
      yield @global_maps[name]
    end
  end

  def observer_reply
    OBSERVER_REPLY.each do |name|
      yield @global_maps[name]
    end
  end

  def has_alts?(name)
    HAS_ALTS.include?(name)
  end

  private
  
  TopDir = Pathname.new(__FILE__) + "../.."

  #
  # All the global sections.  Not actually used.
  #
  # The ones with Independent are scanned by themselves.  The Hotkeys
  # conflict within the set but not outside.
  #
  # The ones marked Conflicts are all mixed together along with each
  # Command Card (one at a time) and there should be no conflicts within
  # that group.
  #
  # The two marked as Group B are essentially one Independent group
  # split into two pieces.
  #
  ALL_GLOBAL_MAPS = [
    "Global-AI.SC2Hotkeys",               # Independent
    "Global-AI2.SC2Hotkeys",              # Independent
    "Global-Camera.SC2Hotkeys",           # Conflicts
    "Global-Chat.SC2Hotkeys",             # Conflicts
    "Global-Chat2.SC2Hotkeys",            # Independent
    "Global-ControlGroups.SC2Hotkeys",    # Conflicts
    "Global-Hero.SC2Hotkeys",             # Independent
    "Global-Inventory.SC2Hotkeys",        # Independent
    "Global-Menu.SC2Hotkeys",             # Conflicts
    "Global-Observer.SC2Hotkeys",         # Group B
    "Global-Replay.SC2Hotkeys",           # Group B
    "Global-TopBarPowers.SC2Hotkeys",     # Independent
    "Global-UI.SC2Hotkeys",               # Conflicts
    "Global-UI2.SC2Hotkeys",              # Independent
    "Global-UIEditor.SC2Hotkeys",         # Independent
    "Global-UnitManagement.SC2Hotkeys",   # Conflicts
    "Global-UnitManagement2.SC2Hotkeys",  # Independent
  ]

  # Global Hotkeys whose defaults include an alternative
  HAS_ALTS = [
    "ChatAll",
    "MinimapNormalView",
    "MinimapTargetingView",
    "ReplayPlayPause",
    "ReplaySkipBack",
    "ReplaySkipNext",
    "ReplaySpeedDec",
    "ReplaySpeedInc"
  ]

  # Global sections whose key bindings conflict with unit and
  # structure commands -- easiest example is Control Groups
  COMMANDS = [
    "Global-Camera.SC2Hotkeys",           # Conflicts
    "Global-Chat.SC2Hotkeys",             # Conflicts
    "Global-ControlGroups.SC2Hotkeys",    # Conflicts
    "Global-Menu.SC2Hotkeys",             # Conflicts
    "Global-UI.SC2Hotkeys",               # Conflicts
    "Global-UnitManagement.SC2Hotkeys",   # Conflicts
  ]

  OBSERVER_REPLY = [
    "Global-Observer.SC2Hotkeys",         # Group B
    "Global-Replay.SC2Hotkeys",           # Group B
  ]

  INDEPENDENT = [
    "Global-AI.SC2Hotkeys",               # Independent
    "Global-AI2.SC2Hotkeys",              # Independent
    "Global-Chat2.SC2Hotkeys",            # Independent
    "Global-Hero.SC2Hotkeys",             # Independent
    "Global-Inventory.SC2Hotkeys",        # Independent
    "Global-TopBarPowers.SC2Hotkeys",     # Independent
    "Global-UI2.SC2Hotkeys",              # Independent
    "Global-UIEditor.SC2Hotkeys",         # Independent
    "Global-UnitManagement2.SC2Hotkeys",  # Independent
  ]

  def read_set(path, keep)
    ret = {}
    (TopDir + path).find do |file|
      next unless file.file?
      temp = HotkeyFile.parse(file.open)
      # For the non-global maps, we want only the Commands section
      temp.sections.keys.each do |key|
        next if keep.include?(key)
        temp.sections.delete(key)
      end
      ret[file.basename.to_s] = temp
    end
    return ret
  end
end
