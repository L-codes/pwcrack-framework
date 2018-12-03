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
    print "[+] Cipher Algorithm: #{passwd.algos.map(&:upcase).join(' or ')}\n\n" unless @@quiet

    if @@select
      @@plugins = @@plugins.select{ |plugin| plugin.name == @@select }
      abort "[!] Not found plugin: '#{@@select}'" if @@plugins.empty?
    end

    threads = []
    @@plugins.each do |plugin|
      plugin.passwd = passwd.cipher
      plugin.algorithms = passwd.algos & plugin.supported_algorithm

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
        puts '(%5.2fs) %17s: %s' % [time, name, result]
      when :notfound
        puts '[-] (%5.2fs) %13s -> Not Found' % [time, name] if @@verbose
      when :remind
        puts '[*] (%5.2fs) %13s: %s' % [time, name, result]
      when :debug
        puts '[!] (%5.2fs) %13s -> %s' % [time, name, result] if @@debug
      end
    end

    r_size = results.size
    success_count = results.count{ |r| [:success, :remind].include? r[1] }
    info = [success_count, r_size, Time.now-start]

    puts '    No password found' if success_count.zero?
    puts
    puts '[+] PWCrack (%d/%d) in %.2f seconds.' % info
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
