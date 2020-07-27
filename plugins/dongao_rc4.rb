#!/usr/bin/env ruby
#
# Plugin dongao rc4
# Author L
#

plugin 'dongao_rc4' do 
  supported_algorithm :dongao_rc4

  crack {
    ciphertext =  [passwd].pack 'H*'
    plaintext = rc4_decrypt(key: '12345678ABCDEFGH', msg: ciphertext)
    plaintext if plaintext.printable?
  }
end

