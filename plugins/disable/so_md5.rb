#!/usr/bin/env ruby
#
# Plugin so_md5
# Author L
#

plugin "so\x6dd5" do 
  web_server "https://www.so\x6dd5.com"
  supported_algorithm :md5, :md5_16, :md4, :sha1, :sha256, :sha384, :sha512, :ntlm, :mysql3, :mysql 

  crack {
    aes = js_require 'aes.js'
    key = md5(passwd)[0,16]
    js = <<-CODE
    String(CryptoJS.AES.encrypt('#{passwd}', CryptoJS.enc.Utf8.parse('#{key}'), {
      iv: CryptoJS.enc.Utf8.parse('#{key}'),
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.ZeroPadding
    }))
    CODE
    sb = aes.eval(js)

    r = nil
    10.times do
      r = get "/ss.php?hash=#{passwd}&api=1&sb=#{sb}"
      break if r.status == 200
      sleep 0.1
    end
    r.body if r.status == 200 && r.body !~ /window\.location/
  }
end

