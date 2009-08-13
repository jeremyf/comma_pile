if RUBY_VERSION =~ /^1\.8/
  require 'fastercsv'
  CSV = FCSV
else
  require 'csv'
end
require 'delegate'

module CommaPile
  class Report < DelegateClass(Hash)
    attr_reader :results

    def initialize(config)
      @config = config
      @results = {}
      super(@results)
    end


    def summary(entry = nil, parent_keys = [])
      collector = ''
      (entry || @results).each do |key, value|
        if value.nil? || value.empty?
          cells = [value.counter] + parent_keys + [key] + value.sum.values
          collector += CSV.generate_line(cells.flatten)
        else
          collector += summary(value, parent_keys + [key])
        end
      end
      collector
    end
    
    def to_stdout(index = 0, entry = nil)
      (entry || @results).each do |key, value|
        puts "#{"\t" * index}#{key}: #{value.counter}"
        if value.respond_to?(:each)
          to_stdout(index + 1, value) if value && !value.empty?
        end
      end
    end
    

    def generate!
      if output
        CSV.open(output.sub(/\.(\w+)$/, '.raw.\1'), 'w+') do |raw_csv|
          @raw_csv = raw_csv
          CSV.open(output, 'w+') do |parsed_csv|
            @parsed_csv = parsed_csv
            @parsed_csv << field_names.collect {|f| f.to_s }
            process_input
          end
        end
      else
        process_input
      end
    end

    protected
    def field_names; @config.field_names; end
    def input; @config.input; end
    def conditions; @config.conditions; end
    def output; @config.output; end
    def line_parser; @config.line_parser; end
    def sum_on_field_names; @config.sum_on; end

    def process_input
      CSV.foreach(input) do |line|
        parse_line(line) do |record|
          with_conditions_met_for(record) do
            render_output_for(record, line)
            accumulate_entry_for(record)
          end
        end
      end
    end

    def register(line)
    end

    def render_output_for(record, line)
      return nil unless output
      @parsed_csv << field_names.inject([]) {|m,v| m << record[v]} if @parsed_csv
      @raw_csv << line if @raw_csv
    end

    def accumulate_entry_for(record)
      field_names.inject(self) do |mem, field_name|
        key = record[field_name]
        mem[key] ||= CommaPile::PivotNode.new
        mem[key].counter += 1
        sum_on_field_names.each do |sum_on_field_name|
          mem[key].add_to(sum_on_field_name, record[sum_on_field_name])
        end
        mem[key]
      end
    end

    def parse_line(line)
      line_parser.with(line) do |record|
        yield(record) if block_given?
      end
    end

    def with_conditions_met_for(record)
      yield and return unless conditions
      yield and return if conditions.respond_to?(:call) && conditions.call(record)
      yield and return if conditions.respond_to?(:all?) && conditions.all?{|(k,v)| record.send(k) =~ (v.is_a?(Regexp) ? v : /^#{Regexp.escape(v)}$/) }
    end

  end
end
