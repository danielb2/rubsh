require 'readline'
Readline.completion_proc = Proc.new do |str|
    Dir[str+'*'].
      grep( /^#{Regexp.escape(str)}/ ). #only return dirs which start with str
      map { |f|  f =~ /\s/ ? "\"#{f}\"" : f } # if names have spaces, then quote
    #Dir[str+'*'].select { |f| File.stat(f).executable? }.grep( /^#{Regexp.escape(str)}/ )
    # + commands_in_path.grep( /^#{Regexp.escape(str)}/ )
end

def commands_in_path
  commands = []
  ENV["PATH"].split(':').each do |dir|
    Dir.glob("#{dir}/*").each do |file|
      begin
        stat = File.stat(file)
        commands << File::basename(file) if stat.executable? and not stat.directory?
      rescue
      end
    end
  end
  return commands
end
