#!/usr/bin/env ruby
#
# Plugin xmd5
# Author L
#

plugin 'xmd5' do
  web_server 'http://xmd5.com'
  supported_algorithm :md5, :md5_16

  crack {
    data = {UserName: "jevoyf46098@chacuo.net", Password: "eEZT1FaD&$S*!t3!Y2d0", logins: "\u767b\u5f55"}
    r = post '/user/CheckLog.asp', data
    unless r.body.empty?
      code = r.body.extract(/checkcode2 type=hidden value="(.+?)">/)
      params = {hash: passwd, xmd5: "MD5 \u89e3\u5bc6", open: "on", checkcode2: code}
      r = get '/md5/search.asp', params, Referer: web_server_url
      r.url.to_s.extract(/info=(.+?)$/)
    end
  }
end

