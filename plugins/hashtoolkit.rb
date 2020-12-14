#!/usr/bin/env ruby
#
# Plugin hashtoolkit
# Author L
# NOTE Website error, unable to access normally
#

plugin 'hashtoolkit' do 
  web_server 'http://hashtoolkit.com'
  supported_algorithm :md5, :sha1, :sha256, :sha384, :sha512

  crack {
    r = get "/reverse-hash?hash=#{passwd}"
    r.body.extract(/Hashes for: <code>(.*?)<\/code>/)
  }
end

