#!/usr/bin/env ruby
#
# Command Line UI Library
# Author L
#

require 'optparse'
require 'base64'
require_relative 'passwd'
require_relative 'cli_cmd/banner'
require_relative 'cli_cmd/updatedb'

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
      opts.banner = 'Usage: ./pwcrack [options] (ciphertext|gets|banner|updatedb) [algorithms...]'

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
      exit 0 if ! cipher or cipher.empty?
    else
      cipher = action
    end

    algos = args
    [cipher, algos]
  end

end

