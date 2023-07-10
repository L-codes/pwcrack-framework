#!/usr/bin/env ruby
#
# Plugin landray_ekp database decrypt
# Author L
# File: WEB-INF/KmssConfig/admin.properties
#

plugin 'interlib' do 
  supported_algorithm :interlib

  crack {
    key = '0002000200020002'.hex2ascii
    plain = algo_decrypt('des-ecb', msg: passwd.hex2ascii, key: key)
    plain if plain&.printable?
  }
end
