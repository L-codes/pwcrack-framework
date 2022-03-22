#!/usr/bin/env ruby
#
# Plugin seeyon_a8 database decrypt
# Author L
#

plugin 'seeyon_a8' do 
  supported_algorithm :seeyon_a8

  crack {
    # /1.1/
    cipher = passwd.hex2ascii
    plain = cipher.bytes.map{ _1 - 1 }.pack 'C*'
    if plain.printable?
      plain

    else
      #/2.4/
      key = ['E6C63180C2806DD1F47B859DE501C15F'].pack 'H*'
      plain = algo_decrypt('sm4-ecb', key: key, msg: cipher)

      plain if plain.printable?
    end
  }
end

