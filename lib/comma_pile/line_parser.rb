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
      line[value]
    end
  end
end
