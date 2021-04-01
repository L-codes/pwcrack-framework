#!/usr/bin/env ruby
#
# Plugin seeyon_a8 database decrypt
# Author L
#

plugin 'seeyon_a8' do 
  supported_algorithm :seeyon_a8

  crack {
    plain = passwd.hex2ascii.bytes.map{ _1 - 1 }.pack 'C*'

    plain if plain.printable?
  }
end

