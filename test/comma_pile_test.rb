require 'test_helper'
require 'example_line_parser'

class CommaPileTest < Test::Unit::TestCase
  CSV_FILE_PATH = File.join(File.dirname(__FILE__), "../test/fixtures/report.csv")

  def output_filename
    @output_filename ||= File.expand_path(File.join(File.dirname(__FILE__), 'tmp/output.csv'))
  end

  should 'not require line_parser' do
    report = CommaPile.new do |config|
      config.source = CSV_FILE_PATH
      config.on = [0]
    end
    report.generate!
    
    assert_equal 3, report['129.74.105.126'].counter
  end

  # CSV_FILE_PATH = '/Users/jeremyf/Downloads/FullMonthlyRpt_Undame_7_2009.csv'
  should 'have results takes a conditions option that is a hash with string value' do
    report = CommaPile.new do |config|
      config.line_parser = ExampleLineParser
      config.source = CSV_FILE_PATH
      config.on = [:project, :viewer_geolocation]
      config.conditions = {:viewer_event => 'play'}
    end
    report.generate!


    assert_equal 6, report['vocation'].counter
    assert_equal 5, report['vocation']['off-campus'].counter
    assert_equal 1, report['vocation']['on-campus'].counter
    assert_equal 85, report['commencement'].counter
    assert_equal 85, report['commencement']['off-campus'].counter
    assert_equal 3, report['innovationpark'].counter
    assert_equal 3, report['innovationpark']['off-campus'].counter
  end

  should 'have results takes a conditions option that is a hash with regular express' do
    report = CommaPile.new do |config|
      config.line_parser = ExampleLineParser
      config.source = CSV_FILE_PATH
      config.on << :project
      config.on << :viewer_event
      config.on << :viewer_geolocation
      config.conditions = {:viewer_event => /(play|stop)/}
    end
    report.generate!
    

    assert_equal 12, report['vocation'].counter
    assert_equal 6, report['vocation']['play'].counter
    assert_equal 5, report['vocation']['play']['off-campus'].counter
    assert_equal 1, report['vocation']['play']['on-campus'].counter
    assert_equal 6, report['vocation']['stop'].counter
    assert_equal 5, report['vocation']['stop']['off-campus'].counter
    assert_equal 1, report['vocation']['stop']['on-campus'].counter
  end

  should 'have results takes a conditions option that is a lambda' do
    report = CommaPile.new do |config|
      config.line_parser = ExampleLineParser
      config.source = CSV_FILE_PATH
      config.field_names << :project
      config.on << :viewer_event
      config.conditions = lambda {|r| r.viewer_event == 'play' || r.project == 'vocation'}
    end
    report.generate!
    
    assert_equal 94, report['vocation'].counter
    assert_equal 6, report['vocation']['play'].counter
    assert_equal 6, report['vocation']['stop'].counter
    assert_nil report['commencement']['stop']
    assert_equal 85, report['commencement']['play'].counter
  end

  should 'have results that no options' do
    report = CommaPile.new do |config|
      config.line_parser = ExampleLineParser
      config.source = CSV_FILE_PATH
      config.on = [:project, :viewer_event, :viewer_geolocation]
      config.conditions = lambda {|r| r.viewer_event == 'play' || r.project == 'vocation'}
    end
    report.generate!
    

    assert_equal 94, report['vocation'].counter
    assert_equal 6,  report['vocation']['play'].counter
    assert_equal 29, report['vocation']['pause'].counter
    assert_equal 28, report['vocation']['unpause'].counter
    assert_equal 25, report['vocation']['seek'].counter
    assert_equal 6, report['vocation']['stop'].counter
  end

  should 'have results that output conditional matches to a file' do
    report = CommaPile.new do |config|
      config.line_parser = ExampleLineParser
      config.input = CSV_FILE_PATH
      config.on = :viewer_event
      config.output = output_filename
      config.conditions = {:viewer_event => 'play'}
    end
    report.generate!
    
    File.readlines(output_filename).each do |line|
      assert_match(/^(viewer_event|play)$/i, line)
      @yielded = true
    end
    assert @yielded
  end

  should 'have sub-results that add up to parent results' do
    report = CommaPile.new do |config|
      config.line_parser = ExampleLineParser
      config.input = CSV_FILE_PATH
      config.on = [:project, :viewer_event]
    end
    
    report.generate!
    

    report.each do |name, collector|
      @yielded = true
      assert_equal collector.counter, collector.inject(0){|m,(k,v)| m += v.counter}
    end

    assert @yielded, "Making sure the above method is called"
  end

  should 'allow column numbers to be used instead of field names' do
    report = CommaPile.new do |config|
      config.line_parser = ExampleLineParser
      config.input = CSV_FILE_PATH
      config.on << :viewer_geolocation
      config.on << 0
    end
    report.generate!
    assert_equal 3, report['on-campus'].counter
    assert_equal 94, report['off-campus']['68.45.25.118'].counter
  end
  
  should "have a summary" do
    report = CommaPile.new do |config|
      config.line_parser = ExampleLineParser
      config.input = CSV_FILE_PATH
      config.on << :viewer_geolocation
      config.on << 0
      config.sum_on << :filesize
    end
    report.generate!
    assert_match /^#{Regexp.escape('1,off-campus,71.103.212.224,92094')}$/, report.summary
  end

  should "allow one or more accumulators" do
    report = CommaPile.new do |config|
      config.line_parser = ExampleLineParser
      config.input = CSV_FILE_PATH
      config.on << :viewer_geolocation
      config.on << 0
      config.sum_on << :filesize
    end
    report.generate!
        
    assert_equal 17155, report['on-campus'].sum[:filesize]
    assert_equal 371622045, report['off-campus'].sum[:filesize]
  end
end
