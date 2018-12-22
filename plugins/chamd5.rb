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
    data = {email: 'czwz@freemail.tweakly.net', pass: '21d7f790a28c90a8c900f9e7f5935b27', type: 'login'}
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
      text = r.body.force_encoding 'UTF-8'
      
      raise InsufficientCredit if text.match? /金币不足,无法进行查询./

      text.extract(/\\"result\\":\\"(.+?)\\"}/)
    end
  }
end

