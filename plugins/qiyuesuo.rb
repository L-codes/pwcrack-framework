#!/usr/bin/env ruby
#
# Plugin qiyuesuo
# Author L
#

plugin 'qiyuesuo' do 
  supported_algorithm :qiyuesuo

  crack {
    ciphertext =  [ passwd.hex2ascii ].pack 'm0'
    plaintext = Crypto::Jasypt.decrypt(ciphertext, 'qiyuesuo@2019')
    plaintext if plaintext.printable?
  }
end

