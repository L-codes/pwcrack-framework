#!/usr/bin/env ruby
#
# Plugin cisco_vpn
# Author L
#
# Cisco VPN Client Password
# Windows : Cisco Systems\VPN Client\Profiles\*.pcf
# OSX     : /private/etc/CiscoSystemsVPNClient/Profiles/*.pcf
# Linux   : /etc/opt/cisco-vpnclient/Profiles/*.pcf
#           ltrace -i ./vpnclient connect ... 2>&1 | fgrep 805ac57

plugin 'cisco_vpn' do 
  supported_algorithm :cisco_vpn

  crack {
    def calc_3des_key(hash)
      get_temp_hash = ->(s, offset){ s[0,19] + (s.getbyte(19) + offset).chr }
      hash1 = sha1(get_temp_hash[hash, 1])
      hash2 = sha1(get_temp_hash[hash, 3])
      hash1 + hash2[0,4]
    end

    data = passwd.hex2ascii
    key = calc_3des_key(data)
    plain = algo_decrypt('des-ede3-cbc', msg: data[40..-1], key: key, iv: data[0,8])
    plain = plain.delete("\x00")
    plain if plain.printable?
  }
end

