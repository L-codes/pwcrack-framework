#!/usr/bin/env ruby
#
# PWCrack Core Library
# Author L
#

require 'thwait'
require_relative 'http'
require_relative 'crypto'
require_relative 'exception'
include PluginExcetption


class PWCrack
  include HTTP
  include Crypto
  using Rainbow
  #include JS  NOTE Disable JS Module

  attr_accessor :name, :passwd, :user, :passwd, :algorithms
  @@plugins = []

  def initialize(name, &block)
    @name = name
    instance_eval &block
    @@plugins << self
  end

  def self.add(name, &block)
    new(name, &block)
  end

  def self.crack(passwd)
    print "[+] Cipher Algorithm: #{passwd.algos.map{|s|s.to_s.upcase.bold}.join(' or ')}\n\n".white unless @@quiet

    if @@select
      select_plugins = @@select.split(',')
      @@plugins = @@plugins.select{ |plugin| select_plugins.include? plugin.name }
      abort "[!] Not found plugin: '#{@@select}'" if @@plugins.empty?
    end

    threads = []
    @@plugins.each do |plugin|
      plugin.algorithms = passwd.algos & plugin.supported_algorithm
      plugin.passwd = passwd.passwd(plugin.algorithms)

      next if plugin.algorithms.empty?
      threads << Thread.new{ plugin.run }
    end

    results = []
    start = Time.now
    ThreadsWait.all_waits(*threads) do |thread|
      results << thread.value
      name, status, result, time = thread.value

      case status
      when :success
        (puts result; exit! 0) if @@quiet
        puts '(%5.2fs) %17s: %s'.green.bold % [time, name, result]
      when :notfound
        puts '[-] (%5.2fs) %13s -> Not Found'.white % [time, name] if @@verbose
      when :remind
        puts '[*] (%5.2fs) %13s: %s'.yellow % [time, name, result]
      when :debug
        puts '[!] (%5.2fs) %13s -> %s'.red.bold % [time, name, result] if @@debug
      when :unkown
        puts '[!] (%5.2fs) %13s -> %s'.red.bold.inverse % [time, name, result] if @@debug
        puts "[!] #{result.backtrace.first}".red.bold.inverse if @@debug
      end
    end

    exit! 1 if @@quiet
    r_size = results.size
    success_count = results.count{ |r| [:success, :remind].include? r[1] }
    info = [success_count, r_size, Time.now-start]

    puts '    No password found'.red if success_count.zero?
    puts
    puts "[+] PWCrack (#{ '%d/%d'.bold}) in #{'%.2f'.bold} seconds.".white % info
  end

  def self.set(opts)
    @@quiet   = opts[:quiet]
    @@select  = opts[:select]
    @@verbose = opts[:verbose]
    @@debug = opts[:debug]
    HTTP.set(opts)
  end

  def run
    start = Time.now
    result = @crack_func.call
    status = result ? :success : :notfound
  rescue Debug => e
    status = :debug
    result = e
  rescue Remind => e
    status = :remind
    result = e
  rescue => e
    status = :unkown
    result = e
  ensure
    return [name, status, result, Time.now - start]
  end

  def crack &block
    @crack_func = block 
  end

  def web_server(url)
    @web_server = url
  end

  def web_server_url
    @web_server
  end

  def supported_algorithm(*algos)
    @supported_algorithm = algos.empty? ? @supported_algorithm : algos
  end

	def enum_algorithm
		return nil unless block_given?
	  algorithms.each do |algorithm|
			r = yield algorithm
			return r if r
		end
		nil
	end

  def self.plugins_info
    Hash.new.tap do |hash|
      @@plugins.map do |plugin|
        hash[plugin.name] = [plugin.web_server_url, plugin.supported_algorithm]
      end
    end
  end

  private_class_method :new
end


def plugin(name, &block)
  PWCrack.add(name, &block)
end
