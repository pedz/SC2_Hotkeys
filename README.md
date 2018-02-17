# Starcraft II Hotkeys

This project is a first stab at making a hotkey file that works
across Verses and Campaign modes without conflicts.

## Discoveries

The hotkeys for the units (e.g. Attack) can not have any modifiers.

I've made other "discoveries" only to now question them.  The best
example is I thought keys in Campaign mode could affect Verses mode
but I then discovered that the conflict that the game was complaining
about
was all within the bindings in Campaign mode.

## Files

empty.SC2Hotkeys - I thought the first thing to do was to find all
of the entries that can be put into a hotkey file which I did by
clearing all of the hotkeys.

defaults.SC2Hotkeys - The next step was to find all of the defaults
for the settings.  This was a super pain.  In this file, generally
speaking, the alternative hotkey (the one after the comma) is a key
I added to get the attribute out into the hotkey file.  There are
a few hotkeys that had two or more settings where I reversed the
two settings and that got the attribute out to the hotkey file.
Last... just to give me a little sanity, I unmapped all the unshifted
numpad keys -- in particular the InventoryButton0-7.  (What the UI
labels "Use Slot 1" through 8.)  Currently, this hotkey file has no
conflicts in Campaign or Verses mode.  I have not tried Co-Op mode.

The Core 4.0 Left Plus.SC2Hotkeys - The version from The Core's
Google repository on the day I happen to download it.

The Core 4.0 Left.SC2Hotkeys - The version from The Core's Google
repository on the day I happen to download it.

The Core 4.0 Right Plus.SC2Hotkeys - The version from The Core's
Google repository on the day I happen to download it.

The Core 4.0 Right.SC2Hotkeys - The version from The Core's Google
repository on the day I happen to download it.

diff-keymap.sh -- A script to make diffing two hotkey files easier.

what-is-missing.sh -- A script that prints out the settings that
the specified hotkey file is missing.
