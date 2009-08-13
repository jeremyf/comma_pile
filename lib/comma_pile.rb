require 'comma_pile/line_parser'
require 'comma_pile/pivot_node'
require 'comma_pile/report'
require 'comma_pile/config'

module CommaPile
  def self.new
    config = CommaPile::Config.new
    yield(config)
    CommaPile::Report.new(config)
  end
end
