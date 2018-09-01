#!/usr/bin/env ruby
#
# Plugin gpp (Group Policy Preferences) crack Groups.xml cpassword
# Author L
#

plugin 'gpp' do 
  supported_algorithm :gpp

  crack {
    key = "\x4e\x99\x06\xe8\xfc\xb6\x6c\xc9\xfa\xf4\x93\x10\x62\x0f\xfe\xe8\xf4\x96\xe8\x06\xcc\x05\x79\x90\x20\x9b\x09\xa4\x33\xb6\x6c\x1b"
    plain = aes_decrypt(msg: passwd.hex2ascii, key: key)
    plain = plain.unpack('v*').pack('C*')

    plain if plain.printable?
  }
end

