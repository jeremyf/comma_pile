require File.join(File.dirname(__FILE__) + '/../lib/comma_pile')
class ExampleLineParser < CommaPile::LineParser
  INDEX_FOR_IP_ADDRESS = 0
  HEADER_VALUE_FOR_IP_ADDRESS = 'c_ip'
  INDEX_FOR_FILENAME = 65
  INDEX_FOR_CLIENT_SIDE_REFERRER = 14
  INDEX_FOR_VIEWER_EVENT = 54
  INDEX_FOR_FILESIZE = 22
  INDEX_FOR_BYTES_STREAMED = 68
  def self.with(line)
    super if line[INDEX_FOR_IP_ADDRESS] != HEADER_VALUE_FOR_IP_ADDRESS
  end

  def live_stream?
    line[INDEX_FOR_IP_ADDRESS].to_i == 0 ? "live-stream" : "pre-recorded-stream"
  end

  def bytes_streamed
    line[INDEX_FOR_BYTES_STREAMED].to_i
  end

  def filesize
    line[INDEX_FOR_FILESIZE].to_i
  end

  def viewer_geolocation
    line[INDEX_FOR_IP_ADDRESS].strip =~ /^129\.74\./ ? "on-campus" : "off-campus"
  end

  def viewer_event
    line[INDEX_FOR_VIEWER_EVENT]
  end

  def project
    line[INDEX_FOR_FILENAME].match(/[\\|\/]?undame[\\|\/]([^\\|\/]*)/i)[1] rescue nil
  end

  def system_name
    File.basename(line[65].gsub(/\\/,'/')) if line[65]
  end

  def referrer
    line[INDEX_FOR_CLIENT_SIDE_REFERRER]
  end
  
  def [](value)
    if value.is_a?(Integer)
      line[value]
    else
      send(value)
    end
  end
end
