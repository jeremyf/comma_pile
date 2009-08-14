module CommaPile
  class LineParser
    def self.with(line)
      yield(new(line))
    end

    attr_reader :line
    def initialize(line)
      @line = line
    end
    
    def [](value)
      if value.is_a?(Integer)
        line[value]
      else
        send(value)
      end
    end
  end
end
