# Script to parse Apache Error logs
#
# A quick script written to parse Apache Error logs.
# Use: ruby error-log.rb [filename]
#
#

class Log
  attr_accessor :errors

  def initialize(logfile)
    @errors = []
    log_file = read(logfile)
    if log_file
      parse(log_file)
      log_file.close
    else
      nil
    end
  end

  def parse_line(line)
    arr = line.strip.split(/\[([^\]]*)\]\s/)
    arr.reject! { |s| s.empty? } # deletes empty strings
    return arr
  end

  def get_ip(text)
    a = text.scan(/[\d+.]+/)
    return a[0]
  end

  def parse(file)
    file.each do |line|
      arr = parse_line(line)
      @errors << Hash[date: arr[0], type: arr[1], ip: get_ip(arr[2]), description: arr[3]]
    end
  end

  def get_all(key)
    return errors.map {|h| h[key]}
  end

  def unique(key)
    a = get_all(key)
    return a.uniq
  end

  def print_value_with_count(key)
    a = unique(key)
    all = get_all(key)
    a.each do |e|
      puts "#{all.count(e)} - #{e}\n"
    end
  end

  def read(filename)
    if File.exists?(filename)
      file = File.open(filename, "r") 
    else
      file = nil
    end
    return file
  end

end

log = Log.new(ARGV[0])

if log
  puts "# - Type of Error\n"
  log.print_value_with_count(:type)

  puts "\n# - Description of Error\n"
  log.print_value_with_count(:description)

  puts "\n...Done!"
else
  puts "Can't find file: #{ARGV[0]}"
end









