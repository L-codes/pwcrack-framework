#!/usr/bin/env ruby
#
# Plugin dmd5
# Author L
#
# NOTE 2018年9月30日起网站停止支持服务

plugin 'dmd5' do 
  web_server 'http://www.dmd5.com'
  supported_algorithm :md5, :md5_16, :sha1, :mysql

  crack {
    enum_algorithm do |algorithm|
      type = case algorithm
             when :md5, :md5_16
               1
             when :sha1
               4
             else
               5
             end
      data = {"method": "crack", "type": type, "md5": passwd}
      r = post '/md5Util.jsp', data
      code = r.body.strip
      data = {"_VIEWRESOURSE": "c4c92e61011684fc23405bfd5ebc2b31", "md5": passwd, "result": code}
      r = post '/md5-decrypter.jsp', data
      r.body.force_encoding 'UTF-8'
      extract(r.body, /<p>解密结果：(.+?)<\/p>/)
    end
  }
end

