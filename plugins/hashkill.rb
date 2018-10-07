#!/usr/bin/env ruby
#
# Plugin hashkill
# Author L
#

plugin 'hashkill' do 
  web_server 'https://www.hashkill.com/'
  supported_algorithm :md5, :md4, :md5_16, :sha1, :sha256, :sha512, :mysql3,
                      :mysql, :lm, :ntlm, :whirlpool, :ripemd160

  crack {
    lc = get('/')&.body.extract(/name="__lc__" value="(.*?)"/)
    post '/co.php', {action: 'checkAction', jyz: 'F'}
    data = {userinfo: '', h: passwd, ht: 'md5', lc: lc, ct: 0, aj: 0}
    r = post '/c.php', data
    r.body.extract /"plain":"(.*?)"/
  }
end
