#!/usr/bin/env ruby
#
# Plugin nitrxgen
# Author L
#

plugin 'nitrxgen' do 
  web_server 'http://www.nitrxgen.net'
  supported_algorithm :md5

  crack {
    r = get "/md5db/#{passwd}"
    r.body unless r.body.empty? or r.body =~ /<html>/
  }
end

