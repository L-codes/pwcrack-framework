#!/usr/bin/env ruby
#
# Plugin xftp version < 5.1
# Author L
#

plugin 'xftp_lt_5.1' do 
  supported_algorithm :xftp

  crack {
    ciphertext =  passwd.hex2ascii
    key = md5 '!X@s#c$e%l^l&'
    plaintext = rc4_decrypt(key: key, msg: ciphertext)
    plaintext if plaintext.printable?
  }
end

