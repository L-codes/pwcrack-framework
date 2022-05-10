#!/usr/bin/env ruby
#
# Plugin landray_ekp database decrypt
# Author L
# File: WEB-INF/KmssConfig/admin.properties
#

plugin 'landray_ekp' do 
  supported_algorithm :landray_ekp

  crack {
    key = 'kmssAdminKey'
    plain = algo_decrypt('des-ecb', msg: passwd.hex2ascii, key: key[0, 8])
    plain if plain&.printable?
  }
end
