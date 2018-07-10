#!/usr/bin/env ruby
#
# Plugin ttmd5
# Author L
#

plugin 'ttmd5' do 
  web_server 'http://ttmd5.com'
  supported_algorithm :md5_16, :md4, :md5, :sha1, :sha256, :sha384, :sha512

  crack {
    r = get "/do.php?c=Decode&m=getMD5&md5=#{passwd}"
    extract(r.body, /"plain":"(.*?)",/)
  }
end

