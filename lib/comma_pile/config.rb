module CommaPile
  class Config
    def initialize
      @field_names = []
      @sum = []
    end
    attr_writer :conditions, :input, :output, :line_parser

    def sum_on; @sum; end
    def sum_on=(value)
      @sum = (@sum << value).flatten.uniq
    end

    def line_parser
      @line_parser ||= CommaPile::LineParser
      if @line_parser.respond_to?(:with) && @line_parser.method(:with).arity == 1
        @line_parser
      else
        raise RuntimeError, "#{self.class.to_s}#line_parser must respond to :with and have an arity of 1.  The line parser will receive an array of fields"
      end
    end

    def output; @output; end
    
    def input; @input || './file.csv'; end
    alias_method :source, :input
    alias_method :source=, :input=
    
    def conditions; @conditions; end
    
    def field_names; @field_names; end
    def field_names=(value)
      @field_names = (@field_names << value).flatten.uniq
    end
    
    alias_method :on, :field_names
    alias_method :on=, :field_names=
  end
  
end