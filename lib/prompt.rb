class Prompt
  def colorize(text, color_code)
      "#{color_code}#{text}\e[0m"
  end

  def self.color(color='default')
    color_map = {
      'blue' => "\e[34m",
      'green' => "\e[32m",
      'cyan' => "\e[36m",
      'default' => "\e[0m",
    }
    return color_map[color] ? color_map[color] : color_map['default']
  end

  def red_text(text); colorize(text, "\e[31m"); end
  def magenta_text(text); colorize(text, "\e[35m"); end

  def green_bg(text); colorize(text, "\e[42m"); end

  def self.parse_map
    return {
      '%h' => `hostname -s`.chomp,
      '%d' => Time.now.strftime('%d'),
      '%u' => Etc.getpwuid.name,
      '%w' => Dir.pwd.gsub(ENV['HOME'],'~'),
      '%W' => File.basename(Dir.pwd.gsub(ENV['HOME'],'~')),
      '%Cb' => color('blue'),
      '%Cc' => color('cyan'),
      '%Cg' => color('green'),
      '%CC' => color,
      '%t' => Time.now.strftime('%H:%M:%S'),
      '%%' => '%',
      '%$' => Process.euid == 0 ? '#' : '$'
    }
  end

  def self.parse(str)
    str = str.dup
    parse_map.each do |key,value|
      str.gsub!(key,value)
    end
    return str
  end
end
