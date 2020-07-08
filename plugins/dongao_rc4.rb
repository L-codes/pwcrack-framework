#!/usr/bin/env ruby
#
# Plugin dongao rc4
# Author L
#

plugin 'dongao_rc4' do 
  supported_algorithm :dongao_rc4

  crack {
    ciphertext =  [passwd].pack 'H*'
    rc4 = OpenSSL::Cipher::RC4.new
    rc4.key = '12345678ABCDEFGH'
    plaintext = rc4.update ciphertext
    plaintext if plaintext.printable?
  }
end

