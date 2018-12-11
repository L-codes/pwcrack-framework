#!/usr/bin/env ruby
#
# Plugin navisec
# Author L
#

plugin 'navisec' do 
  web_server 'https://md5.navisec.it'
  supported_algorithm :md5, :md5_16, :sha1

  crack {
    r = get '/'
    token = r.body.extract(/name="_token" value="(.+?)">/)
    data = {"_token": token, "hash": passwd}
    r = post '/search', data, {Referer: web_server_url}
    r.body.force_encoding 'utf-8'

    case r.body
    when /积分不足/
      raise InsufficientCredit
    when /未能解密/
      nil
    else
      r.body.extract(%r|<code>(.*?)</code>|)
    end
  }
end

