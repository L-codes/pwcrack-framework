#!/usr/bin/env ruby
#
# Plugin richmail db
# Author L
#
# db conf: /home/richmail/newconf/datasources.conf
#

plugin 'richmail' do 
  supported_algorithm :richmail

  crack {
    cipher = passwd.hex2ascii
    key = "NanhangDecrypt$*"
    plain = algo_decrypt('aes-128-ecb', key: key, msg: cipher, padding: 0).strip
    plain if plain.printable?
  }
end

