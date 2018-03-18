
class KeyMap
  def initialize
    @map = {}
  end

  def add(key, attr)
    if k = @map[key]
      puts "Conflict for key #{key} between #{k.path} and #{attr.path}"
    end
    @map[key] = attr
  end
end
