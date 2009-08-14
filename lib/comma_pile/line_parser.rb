module CommaPile
  class LineParser
    def self.define_attribute(name, index = nil, cast_class = nil, &block)
      raise ArgumentError, "You must specify either an :index parameter or a :block for retriving the column information" if (block_given? && index)
      define_method(name, &block) and return if block_given?
      define_method(name) { line[index] } and return if index.is_a?(Integer)
    end
    
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
