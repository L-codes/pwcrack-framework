#!/usr/bin/env ruby
#
# Plugin hashcrack_com
# Author L
# Date   2018-06-18
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

