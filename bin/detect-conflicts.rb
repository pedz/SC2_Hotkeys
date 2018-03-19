#!/usr/bin/env ruby

require 'pathname'
require_relative '../lib/hotkey_file'
require_relative '../lib/key_map'

if ARGV[0] == "--verses-only"
  $verses_only = true
  ARGV.shift
else
  $verses_only = false
end

$top_dir = Pathname.new(__FILE__) + "../.."

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
$all_global_maps = [
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
$has_alts = [
  "ChatAll",
  "MinimapNormalView",
  "MinimapTargetingView",
  "ReplayPlayPause",
  "ReplaySkipBack",
  "ReplaySkipNext",
  "ReplaySpeedDec",
  "ReplaySpeedInc"
]

# Global sections whose key bindings conflict with unit and structure
# commands -- easiest example is Control Groups
$commands = [
  "Global-Camera.SC2Hotkeys",           # Conflicts
  "Global-Chat.SC2Hotkeys",             # Conflicts
  "Global-ControlGroups.SC2Hotkeys",    # Conflicts
  "Global-Menu.SC2Hotkeys",             # Conflicts
  "Global-UI.SC2Hotkeys",               # Conflicts
  "Global-UnitManagement.SC2Hotkeys",   # Conflicts
]

$observer_reply = [
  "Global-Observer.SC2Hotkeys",         # Group B
  "Global-Replay.SC2Hotkeys",           # Group B
]

$independent = [
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

$no_conflicts = [
  "DialogDismiss",
  "MenuGame",
  "MinimapNormalView",
  "MinimapTargetingView",
  "Ping",
  "SelectionCancelDrag",
  "TargetChoose",
  "WarpIn",
]

$global_maps = {}
($top_dir + "Global").find do |file|
  next unless file.file?
  temp = HotkeyFile.parse(file.open)
  # For the global maps, we want only the Hotkeys section
  temp.sections.keys.each do |key|
    next if key == "Hotkeys"
    temp.sections.delete(key)
  end
  $global_maps[file.basename.to_s] = temp
end

$verses_maps = {}
($top_dir + "Verses").find do |file|
  next unless file.file?
  temp = HotkeyFile.parse(file.open)
  # For the non-global maps, we want only the Commands section
  temp.sections.keys.each do |key|
    next if key == "Commands"
    temp.sections.delete(key)
  end
  $verses_maps[file.basename.to_s] = temp
end

$campaign_maps = {}
($top_dir + "Campaign").find do |file|
  next unless file.file?
  temp = HotkeyFile.parse(file.open)
  # For the non-global maps, we want only the Commands section
  temp.sections.keys.each do |key|
    next if key == "Commands"
    temp.sections.delete(key)
  end
  $campaign_maps[file.basename.to_s] = temp
end

# Read in the user's hotkey file
$user_map = HotkeyFile.parse($<)

# For quick access, create a hash that maps the Hotkeys and Commands
# found in the users hotkey file to the attribute (name and key
# binding)
$user_attributes = {}
$user_map.all_attributes.each do |value|
  $user_attributes[value.name] = value
end

# Determine if the users hotkey file as the AllowSetConflicts set to
# 1.
$allow_conflicts = ((s = $user_map.sections["Settings"]) &&
                    (a = s.attributes["AllowSetConflicts"]) &&
                    (a.value.pri == '1'))

# Create the list of command cards the user is interested.  Later, we
# will add in Co-Op and perhaps Arcade mode.
$command_cards = $verses_maps.dup
$command_cards.merge!($campaign_maps) unless $verses_only

# For each command caard the user is interested in, we add the
# commands used by that card to the keymap.  We then add the global
# sections that conflict.  The conflicts are reported as the Hotkeys
# and Commands are added to the keymap.
$command_cards.each do |name, map|
  keymap = KeyMap.new($allow_conflicts)
  path = map.path.sub(/\.[^.]+\z/, '')
  map.all_attributes.each do |attr|
    next if $no_conflicts.include?(attr.name)
    if u = $user_attributes[attr.name]
      u.value.all.each do |key|
        keymap.add(key, u, path: path, default: false)
      end
    else
      if $has_alts.include?(attr.name)
        attr.value.all.each do |key|
          keymap.add(key, attr, path: path, default: true)
        end
      else
        # For these maps, we want only the primary key because the
        # alternative key is something we just made up and is not really
        # the default setting.
        keymap.add(attr.value.pri, attr, path: path, default: true) if attr.value.pri
      end
    end
  end

  $commands.each do |name|
    map = $global_maps[name]
    map.all_attributes.each do |attr|
      next if $no_conflicts.include?(attr.name)
      if u = $user_attributes[attr.name]
        u.value.all.each do |key|
          keymap.add(key, u, path: path, default: false)
        end
      elsif $has_alts.include?(attr.name)
        attr.value.all.each do |key|
          keymap.add(key, attr, path: path, default: true)
        end
      else
        keymap.add(attr.value.pri, attr, path: path, default: true) if attr.value.pri
      end
    end
  end
end

# Check the independent global sections for conflicts.
$independent.each do |name|
  keymap = KeyMap.new($allow_conflicts)
  map = $global_maps[name]
  path = map.path.sub(/\.[^.]+\z/, '')
  map.all_attributes.each do |attr|
    next if $no_conflicts.include?(attr.name)
    if u = $user_attributes[attr.name]
      u.value.all.each do |key|
        keymap.add(key, u, path: path, default: false)
      end
    elsif $has_alts.include?(attr.name)
      attr.value.all.each do |key|
        keymap.add(key, attr, path: path, default: true)
      end
    else
      keymap.add(attr.value.pri, attr, path: path, default: true) if attr.value.pri
    end
  end
end

# Check the Observer and Replay sections for conflicts.
keymap = KeyMap.new($allow_conflicts)
$observer_reply.each do |name|
  map = $global_maps[name]
  path = map.path.sub(/\.[^.]+\z/, '')
  map.all_attributes.each do |attr|
    next if $no_conflicts.include?(attr.name)
    if u = $user_attributes[attr.name]
      u.value.all.each do |key|
        keymap.add(key, u, path: path, default: false)
      end
    elsif $has_alts.include?(attr.name)
      attr.value.all.each do |key|
        keymap.add(key, attr, path: path, default: true)
      end
    else
      keymap.add(attr.value.pri, attr, path: path, default: true) if attr.value.pri
    end
  end
end
