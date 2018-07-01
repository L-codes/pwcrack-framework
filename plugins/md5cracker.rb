#!/usr/bin/env ruby
#
# Plugin md5cracker
# Author L
# Date   2018-06-28
#

plugin 'md5cracker' do 
  web_server 'http://www.md5cracker.com'
  supported_algorithm :md5

  crack {
    r = get "/qkhash.php?option=json&pass=#{passwd}"
    extract(r.body, /"plaintext":"(.+?)",/)
  }
end

