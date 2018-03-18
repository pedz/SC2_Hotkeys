
class MyIO
  # The current line that has been read.
  attr_reader :current_line

  def initialize(io)
    @io = io
    self.gets
  end

  def gets
    if @io.eof?
      @current_line = nil
    else
      @current_line = @io.gets.chomp
    end
  end

  def eof?
    @current_line.nil?
  end
end
