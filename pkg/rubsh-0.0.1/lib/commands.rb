class Commands
  @@oldpwd = nil
  def get_binding
    binding
  end

  def help(arg)
    case arg
    when /help.*prompt/
      puts %|
      %h  - hostname
      %u  - the username of the current user
      %w  - the current working directory, with $HOME abbreviated with a tilde
      %W  - the basename of the current working directory, with $HOME abbreviated
         with a tilde
      %Cb - blue color
      %Cc - cyan color
      %Cg - green color
      %CC - color reset
      %t  - the current time in 24-hour HH:MM:SS format
      %%  - literal %
      %$  - if the effective UID is 0, a #, otherwise a $

      Example: ENV['PR1'] = "[%u@%h]--(%t)\\n\\r[%w]%$ "
      |
    else
      puts %|
    ralias - alias command
      example: ralias 'ls ls -Gh'
      aliases ls to 'ls -Gh'

    shortcuts:
      '...'.ls - shortcut for Dir.glob(...)
      '...'.ls.du is available to do `du` on the files

    prompt:
      use ENV['PR1'] to set your prompt.
      see 'help prompt' for options

    ~/.rubsh/rc.rb
      you can define your aliases, prompt and define
      your own functions in here.

    commandline functions:
      * it gets sent it's own invocation
      * must be a one liner
      example: def test(*a); p a;end  #  test foo #=> ["test foo"]

    |
    end
  end
  def cd(dir)
    dir.gsub! /\s*cd\s*/, ''
    dir.gsub! /\s*$/, ''
    dir.gsub! /("|')/, ''
    if dir.empty?
      @@oldpwd = Dir.pwd
      Dir.chdir ENV['HOME']
      return
    end

    if dir == '-'
      if @@oldpwd
        curdir = Dir.pwd
        Dir.chdir @@oldpwd
        @@oldpwd = curdir
      else
        puts "OLDPWD not set"
      end
      return
    end

    if dir =~ /^~\/?/
      dir.gsub!('~',ENV['HOME'])
    end
    @@oldpwd = Dir.pwd
    Dir.chdir dir
  end
  def method_missing(m,*args)
    if ::Rubsh::iscmd? m.to_s
      system(m.to_s)
      return
    end
    raise "rubsh: #{m}: command not found"
  end
end
