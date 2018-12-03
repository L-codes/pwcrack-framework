#!/usr/bin/env ruby
#
# Plugin navisec
# Author L
#

plugin 'navisec' do 
  web_server 'https://www.mysql-password.com'
  supported_algorithm :mysql

  crack {
    r = post '/api/get-password', {hash: passwd}
    r.body.extract(/"password":"(.*?)"/)
  }
end

