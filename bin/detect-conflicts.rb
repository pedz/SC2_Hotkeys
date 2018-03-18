#!/usr/bin/env ruby

require 'pathname'
require_relative '../lib/hotkey_file'
require_relative '../lib/key_map'

$top_dir = Pathname.new(__FILE__) + "../.."

# Global sections I don't know what to do with yet.
$a = [
  "Global-AI.SC2Hotkeys",
  "Global-Chat.SC2Hotkeys",
  "Global-Hero.SC2Hotkeys",
  "Global-Inventory.SC2Hotkeys",
  "Global-Menu.SC2Hotkeys",
  "Global-Observer.SC2Hotkeys",
  "Global-Replay.SC2Hotkeys",
  "Global-TopBarPowers.SC2Hotkeys",
  "Global-UI.SC2Hotkeys",
  "Global-UIEditor.SC2Hotkeys",
  "Global-UnitManagement.SC2Hotkeys",
]

# Global sections whose key bindings conflict with unit and structure
# commands -- easiest example is Control Groups
$commands = [
  "Global-Camera.SC2Hotkeys",
  "Global-ControlGroups.SC2Hotkeys",
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

$user_map = HotkeyFile.parse($<)
$user_attributes = {}
$user_map.all_attributes.each do |value|
  $user_attributes[value.name] = value
end
$allow_conflicts = false
$allow_conflicts = true if (s = $user_map.sections["Settings"]) &&
                           (a = s.attributes["AllowSetConflicts"]) &&
                           (a.value.pri == '1')
# puts "Conflicts are allowed" if $allow_conflicts

$verses_maps.each do |name, map|
  keymap = KeyMap.new($allow_conflicts)
  path = map.path.sub(/\.[^.]+\z/, '')
  map.all_attributes.each do |attr|
    if u = $user_attributes[attr.name]
      u.value.all.each do |key|
        keymap.add(key, u, path: path, default: false)
      end
    else
      # For these maps, we want only the primary key because the
      # alternative key is something we just made up and is not really
      # the default setting.
      keymap.add(attr.value.pri, attr, path: path, default: true) if attr.value.pri
    end
  end

  $commands.each do |name|
    $global_maps[name].all_attributes.each do |attr|
      if u = $user_attributes[attr.name]
        u.value.all.each do |key|
          keymap.add(key, u, path: path, default: false)
        end
      else
        attr.value.all.each do |key|
          keymap.add(key, attr, path: path, default: true)
        end
      end
    end
  end
end

$campaign_maps.each do |name, map|
  keymap = KeyMap.new($allow_conflicts)
  path = map.path.sub(/\.[^.]+\z/, '')
  map.all_attributes.each do |attr|
    if u = $user_attributes[attr.name]
      u.value.all.each do |key|
        keymap.add(key, u, path: path, default: false)
      end
    else
      # For these maps, we want only the primary key because the
      # alternative key is something we just made up and is not really
      # the default setting.
      keymap.add(attr.value.pri, attr, path: path, default: true) if attr.value.pri
    end
  end

  $commands.each do |name|
    $global_maps[name].all_attributes.each do |attr|
      if u = $user_attributes[attr.name]
        u.value.all.each do |key|
          keymap.add(key, u, path: path, default: false)
        end
      else
        attr.value.all.each do |key|
          keymap.add(key, attr, path: path, default: true)
        end
      end
    end
  end
end
