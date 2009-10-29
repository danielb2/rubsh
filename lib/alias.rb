class Alias
  @@aliases = Hash.new
  def self.parse(str)
    str.scan(/^\s*([^\s]+)(.*)$/) do |name,val|
      @@aliases[name] = val
    end
  end
  def self.[]=(name,value)
    @@aliases[name] = value
  end
  def self.[](name)
    @@aliases[name]
  end
  def self.show
    @@aliases.each do |k,v|
      puts "alias #{k} = #{v}"
    end
  end
end
