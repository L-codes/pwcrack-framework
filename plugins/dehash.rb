#!/usr/bin/env ruby
#
# Plugin dehash
# Author L
#

plugin 'dehash' do 
  web_server 'https://dehash.me'
  supported_algorithm *%i[
    md2 md4 md5 mdc2 ripemd128 ripemd160 ripemd256
    ripemd320 sha1 sha224 sha256 sha384 sha512 whirlpool
  ]

  crack {
    get '/'
    r = post '/', "searchText=#{passwd}&dehash=Dehash+me"
    r.body.extract(%r|<th scope="col">Hash Algorithm</th></tr>\s*<tr>\s*<td>(.*?)</td>|)
  }
end

