require 'fileutils'
require 'commands'
require 'rub_readline'
require 'prompt'
require 'etc'
require 'alias'

def ralias(str)
  Alias.parse(str)
end

class Rubsh
   def initialize()
      Signal.trap('INT') {
         puts "Enter exit/quit to exit shell"
      }
      Signal.trap('SIGKILL') {
         puts "Enter exit/quit to exit shell"
      }
   end

   def self.iscmd?(cmd = nil)
      return nil unless cmd
      return true if File.exists? cmd
      ENV["PATH"].split(':').each do |dir|
         return true if File.exists? "#{dir}/#{cmd.split[0]}"
      end
      return false
   end

   def history
     history_file = ENV['HOME'] + '/.rubsh/history'
     return unless File.exists?  history_file
     IO.readlines("#{ENV['HOME']}/.rubsh/history").each do |line|
       puts line
     end
   end

   def alias(*args)
     if args.size == 0
       Alias.show
       return
     end
     first = args.shift
     Alias[first] = args.join(' ')
   end
   def source(fname)
     load fname
   end

   def parse_cmd(cmd,follow=true)
     exit if cmd =~ /exit|quit/
       exit if cmd == nil
     call,*args = cmd.split
     return unless call
     if Alias[call] and follow #prevent recursion
       parse_cmd Alias[call] + ' ' + args.join(' '), false
     elsif Commands.new.respond_to? call
       begin
         Commands.new.send call, cmd
       rescue
         puts $!
       end
     elsif Rubsh::iscmd? call
       system(cmd)
     else
       begin
         res = eval(cmd,Commands.new.get_binding)
         p res
       rescue Exception
         puts $!
       end
     end
   end

   def parse_cmd2(cmd,follow=true)
     exit if cmd =~ /exit|quit/
     exit if cmd == nil
     call,*args = cmd.split
     return unless call
     if Alias[call] and follow #prevent recursion
       parse_cmd Alias[call] + ' ' + args.join(' '), false
     elsif ::Rubsh::iscmd? call
       system(cmd)
     else
       begin
         p eval(cmd, Commands.new.get_binding)
       rescue Exception
         puts $!
       end
     end
   end

   def log_cmd(cmd)
     @fh = File.open(ENV['HOME'] + '/.rubsh/history','a+') unless @fh
     @fh.puts cmd unless cmd.nil? or cmd =~ /^\s*$/
     @fh.flush
   end

   at_exit { @fh.close if @fh }

   def init_readline
     history_file = ENV['HOME'] + '/.rubsh/history'
     return unless File.exists?  history_file
     IO.readlines(history_file).each do |line|
       line.chomp!
       Readline::HISTORY.push line
     end
   end

   def run
     ENV['PR1'] ||= '[%h:%w] %u%% '
     if not File.exists? "#{ENV['HOME']}/.rubsh"
       FileUtils.mkdir "#{ENV['HOME']}/.rubsh"
     end
     if File.exists? "#{ENV['HOME']}/.rubsh/rc.rb"
       source ENV['HOME'] + '/.rubsh/rc.rb'
     end
     init_readline
     loop do
       prompt = Prompt::parse ENV['PR1']
       cmd = Readline::readline(prompt, true)
       Readline::HISTORY.pop if cmd =~ /^\s*$/
       log_cmd cmd
       parse_cmd cmd
     end
   end
end

class String
  def ls
    Dir.glob self
  end
end

class Array
  def du(opt='')
    switch = ''
    if (opt.class == Symbol)
      switch = '-' + opt.to_s
    else
      switch = opt
    end
    self.each { |f| system("du #{switch} '#{f}'"); }
  end
end
