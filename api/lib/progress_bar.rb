require 'colorize'

module Sentinel
  class ProgressBar
    def initialize(total)
      @i = 0
      @array = Array.new(total,'-'.red)
      @total = total
    end

    def increment
      print("#{@i}\r")
      percent = ((@i+1) * 100) / @total
      @array[@i] = '='.green
      Kernel.print("[#{@array.join}]#{percent}%\r")
      @i += 1
    end
  end
end
