class ExampleLineParser < CommaPile::LineParser
  INDEX_FOR_IP_ADDRESS = 0
  HEADER_VALUE_FOR_IP_ADDRESS = 'c_ip'
  INDEX_FOR_FILENAME = 65
  INDEX_FOR_CLIENT_SIDE_REFERRER = 14
  INDEX_FOR_VIEWER_EVENT = 54
  INDEX_FOR_FILESIZE = 69
  def self.with(line)
    super if line[INDEX_FOR_IP_ADDRESS] != HEADER_VALUE_FOR_IP_ADDRESS
  end

  def filesize
    line[69].to_i
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
