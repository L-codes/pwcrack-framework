#!/usr/bin/env ruby
#
# Command Line UI Library
# Author L
#

require 'optparse'
require 'base64'
require_relative 'passwd'

module CLI
	extend PasswdLib
  using Rainbow

  def self.commandline!
    options = {
           verbose: false,
             quiet: false,
             debug: false,
           nocolor: false,
             retry: 1,
    retry_interval: 0.5,
             proxy: nil,
            select: nil,
           timeout: 5,
      open_timeout: 10
    }
    optparser = OptionParser.new do |opts|
      opts.banner = 'Usage: ./pwcrack [options] (ciphertext|gets|banner) [algorithms...]'

      opts.on('-q', '--quiet', 'Exit when a plaintext is found')
      opts.on('-t', '--timeout second', Integer, "Specify request timeout [default: #{options[:timeout]}]")
      opts.on('-o', '--open-timeout second', Integer, "Specify TCP open timeout [default: #{options[:open_timeout]}]")
      opts.on('-r', '--retry num', Integer, "Retry numbers [default: #{options[:retry]}]")
      opts.on('-i', '--retry-interval second', Float, "Retry Interval seconds [default: #{options[:retry_interval]}]")
      opts.on('-s', '--select plugin_name', String, 'Specify plugins (plugin1[,plugin2...])')
      opts.on('-p', '--proxy "proto://ip:port"', /(?:socks[45]a?|https?):\/\/.+?$/, 'Set Proxy')
      opts.on('-v', '--verbose', 'Run verbosely')
      opts.on('-d', '--debug', 'Run debug mode')
      opts.on('--nocolor', 'Disable color output')
      opts.on('--version', 'Show version') { abort Version }

      opts.separator "\nUse examples:"
      opts.separator "  pwcrack banner"
      opts.separator "  pwcrack updatedb"
      opts.separator "  pwcrack e10adc3949ba59abbe56e057f20f883e"
      opts.separator "  pwcrack e10adc3949ba59abbe56e057f20f883e md5"
      opts.separator "  pwcrack base64:ZTEwYWRjMzk0OWJhNTlhYmJlNTZlMDU3ZjIwZjg4M2UK -s pmd5 "
    end
    optparser.parse! into: options
    abort optparser.help if ARGV.empty?
    puts "[*] Options: #{options}".yellow if options[:debug]
    @@verbose = options[:verbose]

    Rainbow.enabled = false if options[:nocolor]

    passwd = PasswdLib::Passwd.new
    passwd.cipher, algorithms = self.get_input
    passwd_analysis(passwd, algorithms, options[:quiet])
		[passwd, options]
  rescue OptionParser::InvalidArgument,
         OptionParser::MissingArgument,
         OptionParser::InvalidOption    => e
    abort e.message
  end

  
  def self.get_input
    action, *args = ARGV
    
    case action.downcase
    when 'banner'
      self.banner
    when 'updatedb'
      word_file = args.first
      default_word = "#{ROOT}/data/words.txt"
      path = (word_file && File.exist?(word_file)) ? word_file : default_word
      self.updatedb path
    when 'gets'
      require 'readline'
      cipher = Readline.readline("Cipher Text\n#{'>>'.blue} ".bold)
      puts
    else
      cipher = action
    end

    algos = args
    [cipher, algos]
  end


  def self.updatedb(word_file)
    puts "[*] Start creating the local DB..."
    puts

    hashs = {
      :md5    => {},
      :sha1   => {},
      :mysql  => {},
    }
    begin 
      require 'mysql_make_scrambled_password'
    rescue LoadError
      puts "[*] Need to support MySQL hash: `gem install mysql_make_scrambled_password`"
      hashs.delete :mysql
    end
    
    words = open(word_file).each(chomp:true).to_a
    words.each_with_index do |word, i|
      hashs.keys.each do |algo|
        case algo
        when :md5
          hashs[algo][ OpenSSL::Digest::MD5.digest(word)[4,8] ] = i
          # md5(unicode)
          hashs[algo][ OpenSSL::Digest::MD5.digest(word.encode('utf-16le'))[4,8] ] = i
        when :sha1
          hashs[algo][ OpenSSL::Digest::SHA1.digest(word)[5,10] ] = i
        when :mysql
          mysql_hash = MysqlMakeScrambledPassword.make_scrambled_password(word)
          hashs[algo][ [mysql_hash[1..-1]].pack('H*')[5,10] ] = i
        end
      end
    end

    db_dir = "#{ROOT}/data/db"
    Dir.mkdir db_dir unless Dir.exist? db_dir

    dump_obj = lambda do |name, obj|
      filename = "#{db_dir}/#{name}.bin"
      open(filename, 'wb') do |f|
        Marshal.dump(obj, f)
      end
    end

    dump_obj.call("words", words)
    puts "[+] local `words` db (#{words.size}) : data/db/#{name}.bin"

    hashs.each do |algo, obj|
      name = "`#{algo}`".center 7
      dump_obj.call(algo, obj)
      puts "[+] local #{name} db (#{obj.size}) : data/db/#{algo}.bin"
    end

    exit
  end


  def self.banner
    puts Banner
    plugin_map = PWCrack.plugins_info 

    web_urls = plugin_map.map{|_, (web, _)| web}
    puts "                       [ Plugin Count ] "
    puts
    algo_sum = web_urls.count nil
    web_sum  = web_urls.size - algo_sum
    puts "         Online Plugin: #{web_sum}        Offline Plugin: #{algo_sum}"
    if @@verbose
      puts
      plugin_map.each do |name, (web, _)|
        next if web.nil?
        puts "      %18s    %s" % [name, web]
      end
    end
    puts

    algo_count = plugin_map.map{|_, (_, algos)| algos}
                           .flatten.group_by(&:itself)
                           .transform_values(&:size)
                           .sort_by{|k,v| v}
                           .reverse
    puts "                  [ Algorithm Plugin Count ] "
    puts
    algo_count.map{|item| '%15s: %2d' % item}.each_slice(3) do |line|
      puts line.join ' '
    end
    puts

    exit
  end

  Banner = <<-EOF
                                             

                                             
          "$$$$$$\''  'M$  '$$$@m            
        :$$$$$$$$$$$$$$''$$$$'               
       '$'    'JZI'$$&  $$$$'                
                 '$$$  '$$$$                 
                 $$$$  J$$$$'                
                m$$$$  \$$$$,                
                $$$$@  '$$$$_         #{Project}
             '1t\$$$$' '$$$$<               
          '$$$$$$$$$$'  $$$$          version #{Version}
               '@$$$$'  $$$$'                
                '$$$$  '$$$@                 
             'z$$$$$$  @$$$                  
                r$$$   $$|                   
                '$$v c$$                     
               '$$v $$v$$$$$$$$$#            
               $$x$$$$$$$$$twelve$$$@$'      
             @$$$@L '    '<@$$$$$$$$`        
           $$                 '$$$           
                                             

    [ Github ] https://github.com/L-codes/#{Project}

  EOF
end

