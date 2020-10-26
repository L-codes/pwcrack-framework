#!/usr/bin/env ruby
#
# Plugin 大汉通版 JIS 统一认证平台
# Author L
#

plugin 'dahan_jis' do 
  supported_algorithm :dahan_jis

  crack {
    ciphertext = passwd.hex2ascii

    key = md5_hex('jcms2008').upcase.each_byte.cycle

    plaintext = ciphertext.each_byte.each_slice(2).map {|a, b|
      (a ^ key.next) ^ (b ^ key.next)
    }.pack 'C*'

    plaintext if plaintext.printable?
  }
end
