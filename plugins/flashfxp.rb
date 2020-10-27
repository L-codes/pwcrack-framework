#!/usr/bin/env ruby
#
# Plugin FlashFxp (only sites.dat)
# Author L
#

plugin 'flashfxp' do 
  supported_algorithm :flashfxp

  crack {
    ciphertext =  passwd.hex2ascii
    key = 'yA36zA48dEhfrvghGRg57h5UlDv3'.each_byte.cycle

    plaintext = ciphertext.each_byte.each_cons(2).map {|a, b|
                  n = ( b ^ key.next ) - a
                  n % 255
                }.pack 'C*'

    plaintext if plaintext.printable?
  }
end

