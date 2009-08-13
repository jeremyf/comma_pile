module CommaPile
  class PivotNode < Hash
    attr_reader :sum
    def initialize
      @sum = {}
    end
    
    attr_writer :counter
    def counter; @counter ||= 0; end
    
    def inspect
      "(counter: #{counter}; hash:#{super})"
    end
    
    def add_to(fieldname, value)
      self.sum[fieldname] ||= 0
      self.sum[fieldname] += value
    end
  end
end
