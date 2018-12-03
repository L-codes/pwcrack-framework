#!/usr/bin/env ruby
#
# Plugin mysql_password
# Author L
#

plugin 'mysql_password' do 
  web_server 'https://www.mysql-password.com'
  supported_algorithm :mysql

  crack {
    r = post '/api/get-password', {hash: passwd}
    r.body.extract(/"password":"(.*?)"/)
  }
end

