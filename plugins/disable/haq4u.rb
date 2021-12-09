#!/usr/bin/env ruby
#
# Plugin haq4u
# Author L
# NOTE Website error, unable to access normally
#

plugin 'haq4u' do 
  web_server 'http://haq4u.com'
  supported_algorithm :md5, :sha1

  crack {
    r = get "http://#{passwd}.haq4u.com"
    r.body.extract(/\.haq4u\.com">(.+?)<\/a><\/br>/)
  }
end

