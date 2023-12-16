#!/usr/bin/env ruby
#
# Plugin jboss database decrypt
# Author L
#

plugin 'jboss' do 
  supported_algorithm :jboss

  crack {
    plain = algo_decrypt 'bf-ecb', key: 'jaas is the way', key_len: 15, msg: passwd.hex2ascii
    plain if plain.printable?
  }
end

