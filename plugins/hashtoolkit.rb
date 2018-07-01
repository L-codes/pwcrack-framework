#!/usr/bin/env ruby
#
# Plugin hashtoolkit
# Author L
# Date   2018-06-18
#

plugin 'hashtoolkit' do 
  web_server 'http://hashtoolkit.com'
  supported_algorithm :md5, :sha1, :sha256, :sha384, :sha512

  crack {
    r = get "/reverse-hash?hash=#{passwd}"
    extract(r.body, /Hashes for: <code>(.*?)<\/code>/)
  }
end

