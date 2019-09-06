#!/usr/bin/env ruby
#
# Plugin md5online
# Author L
#

plugin 'md5online' do 
  web_server 'https://www.md5online.org'
  supported_algorithm :md5

  crack {
    r = post '/md5-decrypt.html', {hash: passwd}
    r.body.extract(%r|Found : <b>(.*?)</b></span><br>\(hash|)
  }
end

