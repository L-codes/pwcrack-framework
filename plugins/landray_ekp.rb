#!/usr/bin/env ruby
#
# Plugin landray_ekp database decrypt
# Author L
#

if Kernel.const_defined? :Rjb

plugin 'landray_ekp' do 
  supported_algorithm :landray_ekp

  crack {
    EKPDESEncrypt = Rjb.import 'com.landray.kmss.util.DESEncrypt'
    plain = ""
    [false, true].find { |israndom|
      des = EKPDESEncrypt.new("kmssAdminKey", israndom)
      plain = des.decrypt(passwd.hex2ascii) rescue nil
    }
    plain if plain.printable?
  }
end

end
