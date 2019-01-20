#!/usr/bin/env ruby
#
# PWCrack ENV Library
# Author L
#

ENV['BUNDLE_GEMFILE'] = "#{ROOT}/Gemfile"
require 'bundler/setup'

# load all external
#Dir["#{ROOT}/external/**/*.rb"].each do |external|
#  require_relative external
#end

autoload :MessagePack, 'msgpack'
autoload :Base64,      'base64'
autoload :OpenSSL,     'openssl'
autoload :Readline,    'readline'
autoload :JSON,        'json'
autoload :ProgressBar, 'ruby-progressbar'

trap("INT"){ puts "\r[!!!] Interrupt. ".red; exit! 1 }
require 'rainbow/refinement'
using Rainbow
