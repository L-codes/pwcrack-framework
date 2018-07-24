#!/usr/bin/env ruby
#
# PWCrack Core Library
# Author L
#

require 'thwait'
require_relative 'http'
require_relative 'crypto'

class PWCrack
  include HTTP
  include Crypto

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
      threads << Thread.new{[plugin.name, plugin.run]}
    end

    results = []
    start = Time.now
    ThreadsWait.all_waits(*threads) do |thread|
      name, (result, time) = thread.value
      if @@quiet
        if results.include? result
          puts result
          exit
        end
      elsif result
        puts '(%5.2fs) %17s: %s' % [time, name, result]
      else
        puts '[-] (%5.2fs) %13s: Not Found' % [time, name]
      end
      results << result
    end

    if @@quiet
      puts results.first if results.first
    else
      r_size = results.size
      info = [r_size, r_size-results.count(nil), Time.now-start]
      puts '    No password found' if results.none?
      puts
      puts '[+] PWCrack (%d/%d) in %.2f seconds.' % info
    end
  end

  def self.set(opts)
    @@quiet   = opts.fetch(:quiet, nil)
    @@select  = opts.fetch(:select, nil)
    HTTP.set(opts)
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

  def run
    start = Time.now
    result = @crack_func.call
    [result, Time.now - start]
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
