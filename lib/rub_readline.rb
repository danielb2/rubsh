require 'readline'
def get_local_dirs(str)
  Dir[str+'*'].
    grep( /^#{Regexp.escape(str)}/ ). #only return dirs which start with str
    map { |f|  f =~ /\s/ ? "\"#{f}\"" : f } # if names have spaces, then quote
end

# tab completion here is bad because we don't know if the str has a 'cd' before it.
# That makes us go through the executables as well when we're doing cd str[TAB]
def get_executables(str)
  commands = []
  ENV["PATH"].split(':').each do |dir|
    Dir.glob("#{dir}/*").grep( /#{File::SEPARATOR}?#{Regexp.escape(str)}/ ).each do |file|
      begin
        stat = File.stat(file)
        commands << File::basename(file) if stat.executable? and not stat.directory?
      rescue
      end
    end
  end
  return commands
end
Readline.completion_proc = Proc.new do |str|
  completions = get_local_dirs(str)
  
  # if it's the first thing we're typing in, assume this to be a command and not just a dir.
  # iow, we don't do this for second arg allowing executables not to be completed when
  # prefixed by example 'cd'.
  if Readline.line_buffer =~ /^\s*#{Regexp.escape(str)}/
    completions += get_executables(str)
  end
  completions
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
