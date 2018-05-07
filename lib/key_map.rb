
class KeyMap
  class Record
    # The name of the attribute
    attr_reader :name
    
    def initialize(attr, options)
      @attr = attr
      @path = options[:path]
      @default = options[:default]
      @name = attr.name
    end
    
    def to_s
      if @default
        "default setting for #{@attr.name}"
      else
        "user setting from '#{@attr.map_name}' for #{@attr.name}"
      end
    end
  end

  def initialize(allow_conflicts)
    @allow_conflicts = allow_conflicts
    @map = {}
  end

  # These Hotkeys do not seem to conflict with anything -- ever.
  NO_CONFLICTS = [
    "DialogDismiss",
    "MenuGame",
    "MinimapNormalView",
    "MinimapTargetingView",
    "Ping",
    "SelectionCancelDrag",
    "TargetChoose",
    "WarpIn",
  ]

  CONFLICT_PAIRS = {
    "GhostHoldFire/Ghost" => "WeaponsFree/Ghost",
  }

  def add(key, attr, options)
    path = options[:path]
    default = options[:default]
    r = Record.new(attr, options)
    if (k = @map[key]) &&
       ((@allow_conflicts == false) ||
        ((@allow_conflicts == true) &&
         (CONFLICT_PAIRS[k.name] != attr.name) &&
         (CONFLICT_PAIRS[attr.name] != k.name)))
      puts "While checking #{path}, key #{key} used for #{k} conflicts with #{r}"
    end
    @map[key] = r
  end
end
