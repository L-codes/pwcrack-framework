#!/usr/bin/env ruby
#
# Plugin bugbank
# Author L
#

plugin 'bugbank' do 
  web_server 'https://www.bugbank.cn'
  supported_algorithm :md5, :md5_16, :sha1

  crack {
    r = post '/api/md5', {md5text: passwd}
    r.body.extract(/"answer":"(.+?)"/)
  }
end

