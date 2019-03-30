#!/usr/bin/env ruby
#
# Plugin passwordrecovery
# Author L
#

plugin 'passwordrecovery' do 
  web_server 'https://passwordrecovery.io'
  supported_algorithm :md5, :sha1, :sha256, :sha512

  crack {
    enum_algorithm do |algorithm|
      r = post "/#{algorithm}", "hashinput=#{passwd}&thetest=get#{algorithm}&name_of_nonce_field="
      r.body.extract(/Found: <b>(.+?)\s+<\/b>/)
    end
  }
end

