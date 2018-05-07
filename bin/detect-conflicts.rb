#!/usr/bin/env ruby

require 'pathname'
require_relative '../lib/hotkey_file'
require_relative '../lib/key_map'
require_relative '../lib/default_keymaps'

# This isn't really part of KeyMap nor HotkeyFile... it is a very
# unique routine specific for detecting conflicts.  So, for now, I'm
# just going to leave it defined in the global space.
def process_map(map, keymap, path)
  map.all_attributes.each do |attr|
    next if KeyMap::NO_CONFLICTS.include?(attr.name)
    if u = $user_attributes[attr.name]
      u.value.all.each do |key|
        keymap.add(key, u, path: path, default: false)
      end
    elsif DefaultKeymaps.instance.has_alts?(attr.name)
      attr.value.all.each do |key|
        keymap.add(key, attr, path: path, default: true)
      end
    else
      keymap.add(attr.value.pri, attr, path: path, default: true) if attr.value.pri
    end
  end
end

if ARGV[0] == "--verses-only"
  $verses_only = true
  ARGV.shift
else
  $verses_only = false
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
$allow_conflicts = $user_map.allow_conflicts

# Create the list of command cards the user is interested.  Later, we
# will add in Co-Op and perhaps Arcade mode.
$command_cards = DefaultKeymaps.instance.verses_maps.dup
$command_cards.merge!(DefaultKeymaps.instance.campaign_maps) unless $verses_only

# For each command caard the user is interested in, we add the
# commands used by that card to the keymap.  We then add the global
# sections that conflict.  The conflicts are reported as the Hotkeys
# and Commands are added to the keymap.
$command_cards.each do |name, map|
  keymap = KeyMap.new($allow_conflicts)
  path = map.path.sub(/\.[^.]+\z/, '')
  process_map(map, keymap, path)
  DefaultKeymaps.instance.commands do |map2|
    process_map(map2, keymap, path)
  end
end

# Check the independent global sections for conflicts.
DefaultKeymaps.instance.independent do |map|
  keymap = KeyMap.new($allow_conflicts)
  path = map.path.sub(/\.[^.]+\z/, '')
  process_map(map, keymap, path)
end

# Check the Observer and Replay sections for conflicts.
keymap = KeyMap.new($allow_conflicts)
DefaultKeymaps.instance.observer_reply do |map|
  path = map.path.sub(/\.[^.]+\z/, '')
  process_map(map, keymap, path)
end
