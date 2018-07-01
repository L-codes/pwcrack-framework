#!/usr/bin/env ruby
#
# Plugin gongjuji
# Author L
# Date   2018-06-28
#

plugin 'gongjuji' do 
  web_server 'http://md5.gongjuji.net'
  supported_algorithm :md5, :md5_16

  crack {
    r = get "/common/md5dencrypt\?UpperCase=#{passwd}", {'decode': passwd}
    extract(r.body, /PlainText":"(.+?)",/)
  }
end

