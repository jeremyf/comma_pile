CommaPile
==========

A simple gem for processing and aggregating CSV files.  CommaPile builds a table that count

Config Options:

  * **source** - What is the name of the source csv file [**REQUIRED**, **SINGLE**]
  * **on** - Specify any number of columns [**REQUIRED**, **MULTIPLE**]
  * **sum_on** - Specify a column that you want to accumulate given [**OPTIONAL**, **MULTIPLE**]
  * **conditions** - Specify a lambda, key-value pair that must be met for line to be
      part of the compilation [**OPTIONAL**, **MULTIPLE**]
  * **output** - Specify a path to output the compiled data; In addition a raw file,
      containing all rows that were used in the compilation, is generated. [**OPTIONAL**, **SINGLE**]
  * **line_parser** - Specify a custom line parser to use; By default CommaPile::LineParser is used.
      A custom line parser would allow for transformation of data during compilation.  See
      test/example\_line\_parser.rb [**OPTIONAL**, **SINGLE**]
  
Example
-------
    File.open('/path/to/input.csv', 'w+') do |file|
      file.puts %('Work', 'Build CommaPile',2009-09-12,2)
      file.puts %('Work', 'Build CommaPile',2009-09-13,1)
      file.puts %('Work', 'Chase Chickens', 2009-09-12,4)
      file.puts %('Work', 'Read Developer Blogs',2009-09-13,1)
      file.puts %('Home', 'Do Dishes', 2009-09-12, 0.5)
    end

    require 'comma_pile'
    
    report = CommaPile.new do |config|
      config.source = '/path/to/input.csv'
      config.on << 0
      config.on << 1
      config.sum_on << 3
      config.output = '/path/to/output.csv'
      config.conditions = lambda {|r| r[1] == /^Chase/ }
    end
    
    report.generate!
    
    report['Work'].counter == 3
    report['Work'].sum[3] == 4
    report['Work']['Build CommaPile'].counter == 2
    report['Work']['Build CommaPile'].sum[3] == 3
    report['Home'].sum[3] == 0.5


Copyright
---------

Copyright (c) 2009 Jeremy Friesen. See LICENSE for details.
