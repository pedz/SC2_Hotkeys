

# Load up user's keymap.
#
# Check conflicts with Independent and Replay+Observer.
#   If there are conflicts, just tell the user and stop (I guess).
#
# Add in the Global Command Hotkeys that the user's keymap does not have.
#   i.e. add in the default bindings of the Hotkeys that can conflict
#   with Commands
#
# Scan the Command Cards and create a hash with the first alternate as
# the key (which represents the position of the command in the command
# card) and the value an array of the unique commands.  Call this the
# Position to Commands hash.
#
# Also create a hash of the opposite direction with the Command as the
# key and the first alternate as the value.  Call this the Command =>
# Position hash.
#
# Scan the Command Cards.  For each Command that conflicts, find its
# physical location which will be the first alternate.  Use the
# Position to Key hash to get a list of possible keys to bind the
# command to.  Take the first one that does not create a conflict.
#
# Position to Array of Keys hash:  For a particular position in the
# Command Card which we get by looking at the first alternative of the
# Command Cards, we want a list of keys that the User keymap has in
# that position.
