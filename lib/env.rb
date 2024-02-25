#!/usr/bin/env ruby
#
# PWCrack ENV Library
# Author L
#

ruby_run_version = '2.5.0'
if Gem::Version.new(RUBY_VERSION) < Gem::Version.new(ruby_run_version)
  abort "[!] Please run with ruby#{ruby_run_version}+"
end

ENV['BUNDLE_GEMFILE'] = "#{ROOT}/Gemfile"
require 'bundler/setup'

# load all external
disable_external = %w{ javascript }
Dir.each_child("#{ROOT}/external") do |external|
  next if disable_external.include? external
  load "#{ROOT}/external/#{external}/#{external}.rb"
end

require 'openssl'

if OpenSSL::VERSION >= '3.0.0' && defined?(OpenSSL::Provider)
  OpenSSL::Provider.load("legacy")
end

autoload :MessagePack, 'msgpack'
autoload :Base64,      'base64'
autoload :Readline,    'readline'
autoload :JSON,        'json'
autoload :ProgressBar, 'ruby-progressbar'

trap("INT"){ puts "\r[!!!] Interrupt. ".red; exit! 1 }
require 'rainbow/refinement'
using Rainbow
