#!/usr/bin/env ruby
#
# Plugin hashcrack_com
# Author L
#

plugin 'hashcrack_com' do 
  web_server 'http://hashcrack.com'
  supported_algorithm :md5, :sha1, :lm, :ntlm, :mysql3, :mysql

  crack {
    data = {'auth':'8272hgt', 'hash':passwd, 'string':'', 'Submit':'Submit'}
    r = post "/index.php", data
    extract(r.body, /<span class=hervorheb2>(.*?)<\/span><\/div><\/TD>/)
  }
end

