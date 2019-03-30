#!/usr/bin/env ruby
#
# Plugin dehash
# Author L
#

plugin 'dehash' do 
  web_server 'https://dehash.me'
  supported_algorithm *%i[
    md2 md4 md5 mdc2 ripemd128 ripemd160 ripemd256
    ripmd320 sha1 sha224 sha256 sha384 sha512 whirlpool
  ]

  crack {
    get '/'
    r = post '/', "input-text=#{passwd}&dehash-button="
    r.body.extract(%r|<th>Hash Algorithm</th></tr><tr><td>(.*?)</td>|)
  }
end

