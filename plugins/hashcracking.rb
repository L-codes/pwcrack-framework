#!/usr/bin/env ruby
#
# Plugin hashcracking
# Author L
# Date   2018-06-28
#

plugin 'hashcracking' do 
  web_server 'https://hashcracking.ru'
  supported_algorithm :md5, :sha1, :mysql3, :mysql

  crack {
    r = post '/', {'pass':'', 'hash': passwd}
    extract(r.body, /" value="(.+?)" maxlength="32">/)
  }
end

