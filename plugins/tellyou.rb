#!/usr/bin/env ruby
#
# Plugin tellyou
# Author L
#

plugin 'tellyou' do 
  web_server 'http://md5.tellyou.top'
  supported_algorithm :md5, :md5_16

  crack {
    data    = {Ciphertext: passwd}
    headers = {'X-Forwarded-For': '192.168.1.1'}
    r = post '/MD5Service.asmx/HelloMd5', data, headers
    r.body.extract(/org\/">(.*?)<\/string>/)
  }
end

