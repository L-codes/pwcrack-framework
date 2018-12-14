#!/usr/bin/env ruby
#
# Plugin pmd5
# Author L
#

plugin 'pmd5' do 
  web_server 'http://api.pmd5.com'
  supported_algorithm :md5, :md5_16

  crack {
    r = get '/pmd5api/pmd5', {'pwd': passwd}
    r.body.extract(/:"(.*?)"}}/)
  }
end

