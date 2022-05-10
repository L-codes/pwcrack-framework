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

    if Kernel.const_defined? :Rjb
      EKPDESEncrypt = Rjb.import 'com.landray.kmss.util.DESEncrypt'
      plain = ""
      [false, true].find { |israndom|
        des = EKPDESEncrypt.new(key, israndom)
        plain = des.decrypt(passwd.hex2ascii) rescue nil
      }

    else
      plain = algo_decrypt('des-ecb', msg: passwd.hex2ascii, key: key[0, 8])

    end

    plain if plain&.printable?
  }
end
