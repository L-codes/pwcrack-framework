#!/usr/bin/env ruby
#
# Plugin nitrxgen
# Author L
# Date   2018-06-24
#

plugin 'nitrxgen' do 
  web_server 'http://www.nitrxgen.net'
  supported_algorithm :md5

  crack {
    r = get "/md5db/#{passwd}"
    r.body unless r.body.empty? or r.body =~ /<html>/
  }
end

