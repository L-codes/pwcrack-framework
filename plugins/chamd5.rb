#!/usr/bin/env ruby
#
# Plugin chamd5
# Author L
#
# NOTE 查询需要积分

plugin 'chamd5' do 
  web_server 'http://www.chamd5.org/'
  supported_algorithm :md5, :sha1, :mysql3, :mysql, :lm, :ntlm

  crack {
    data = {'email': 'nkitvg69570@chacuo.net','pass': '5c2f2b01245f43f9a5f703a96a6ac4a6','type': 'login'}
    post_json '/HttpProxyAccess.aspx/ajax_login', data
    enum_algorithm do |algorithm|
      type = case algorithm
             when :md5, :lm, :ntlm
               'md5'
             when :sha1
               '100'
             when :mysql3
               '200'
             when :mysql
               '300'
             end
      data = {'hash': passwd, 'type': type}
      r = post_json '/HttpProxyAccess.aspx/ajax_me1ody', data
      r.body.extract(/\\"result\\":\\"(.+?)\\"}/)
    end
  }
end

