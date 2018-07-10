#!/usr/bin/env ruby
#
# Plugin 80p
# Author L
#

plugin '80p' do 
  web_server 'http://md5.80p.cn'
  supported_algorithm :md5, :md5_16, :sha1

  crack {
    r = post '/', {'decode': passwd}
    extract(r.body, /<font color="#FF0000">(.*?)<\/font>/)
  }
end

