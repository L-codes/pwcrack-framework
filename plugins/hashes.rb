#!/usr/bin/env ruby
#
# Plugin hashes
# Author L
#

plugin 'hashes' do 
  web_server 'https://hashes.com'
  supported_algorithm :md5, :sha1, :mysql3, :mysql, :ntlm, :sha256, :sha512

  crack {
    r = get '/en/decrypt/hash'
    csrf_token = r.body.extract(/name="csrf_token" value="([^"]+)"/)

    r = post "/en/decrypt/hash", "csrf_cookie=#{csrf_token}&hashes=#{passwd}&knn=64&submitted=true"
    r.body.extract(/#{passwd}:(.+?)<\/div>/)
  }
end

