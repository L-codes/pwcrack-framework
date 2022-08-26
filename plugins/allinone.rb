#!/usr/bin/env ruby
#
# Plugin allinone
# Author L
#

plugin 'allinone' do 
  web_server 'https://api.allinone.tools/'
  supported_algorithm :md5, :sha1, :sha256, :sha384, :sha512

  crack {
    enum_algorithm do |algorithm|
      r = get "/encryption/decrypt/#{algorithm}/#{passwd}"
      r.body if r.body != 'Password not found !'
    end
  }
end

