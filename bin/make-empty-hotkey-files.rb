#!/usr/bin/env ruby

File.open("/Users/pedz/Library/Application Support/Blizzard/StarCraft II/Accounts/71687501/Hotkeys/old/txt/default-key-positions.txt", "r") do |f|
  f.each_line do |line|
    line.chomp!
    md = /\A(?<plus>\+*)(?<rest>[^+]*)\Z/.match(line)
    case md[:plus].length
    when 5
      @mode = md[:rest].gsub(/[ ()]/, "")
      # puts "5 #{@mode}"
      
    when 4
      @area = md[:rest].gsub(/[ ()]/, "")
      @units = {}
      # puts "4 #{@area}"
      
    when 3
      @u_or_s = md[:rest].gsub(/[ ()]/, "")
      # puts "3 #{@u_or_s}"
      
    when 2
      @thing = md[:rest].gsub(/[ ()]/, "")
      if @units.has_key?(@thing)
        @units[@thing] += 1
      else
        @units[@thing] = 1
      end
      @num = 0
      # puts "2 #{@thing}"
      
    when 1
      @card = md[:rest].gsub(/[ ()]/, "")
      if (cnt = @units[@thing]) == 1
        cnt = ""
      end
      if @u_or_s == "Units" && @num == 0 && @card == "General"
        from = "moves.SC2Hotkeys"
      else
        from = "start.SC2Hotkeys"
      end
      # if @mode == "Campaign"
        puts "mkdir -p #{@mode}/#{@area}"
        puts "cp #{from} #{@mode}/#{@area}/#{@mode}-#{@area}-#{@thing}#{cnt}-#{@num}-#{@card}.SC2Hotkeys"
      # end
      @num += 1
      # puts "1 #{@card}"
      
    when 0
      @foo = md[:rest]
      # puts "0 #{@foo} #{@mode}"
    end
  end
end
