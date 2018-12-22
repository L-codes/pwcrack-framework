#!/usr/bin/env ruby
#
# Plugin so_md5
# Author L
#

plugin "somd5" do 
  web_server "https://www.somd5.com"
  supported_algorithm :md5, :md5_16, :md4, :sha1, :sha256, :sha384, :sha512, :ntlm, :mysql3, :mysql, :whirlpool

  crack {
    r = post '/search.php', {hash: passwd, captcha: 0}
    r.body.extract(/"data":"(.*?)"/)
  }
end

