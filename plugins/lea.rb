#!/usr/bin/env ruby
#
# Plugin lea
# Author L
#

plugin 'lea' do 
  web_server 'https://lea.kz'
  supported_algorithm :md5, :sha1, :sha224, :sha256, :sha384, :sha512

  crack {
    r = get "/api/hash/#{passwd}"
    extract(r.body, /"password": "(.*?)"/)
  }
end

