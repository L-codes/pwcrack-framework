#!/usr/bin/env ruby
#
# Plugin hashcracking
# Author L
# NOTE Faraday::ConnectionFailed: execution expired
#

plugin 'hashcracking' do 
  web_server 'https://hashcracking.ru'
  supported_algorithm :md5, :sha1, :mysql3, :mysql

  crack {
    r = post '/', {'pass':'', 'hash': passwd}
    r.body.extract(/" value="(.+?)" maxlength="32">/)
  }
end

