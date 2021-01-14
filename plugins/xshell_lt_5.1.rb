#!/usr/bin/env ruby
#
# Plugin xshell version < 5.1
# Author L
# PATH: %AppData%\NetSarang\Xshell\Sessions
#

plugin 'xshell_lt_5.1' do 
  supported_algorithm :xshell

  crack {
    ciphertext =  passwd.hex2ascii
    key = md5 '!X@s#h$e%l^l&'
    plaintext = rc4_decrypt(key: key, msg: ciphertext)
    plaintext if plaintext.printable?
  }
end

