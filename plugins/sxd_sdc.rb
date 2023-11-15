#!/usr/bin/env ruby
#
# Plugin shenxinda_sdc decrypt
# Author L
#

plugin 'sxd_sdc' do 
  supported_algorithm :sxd_sdc

  crack {
    key = "\x00\x1F\x01\x1E\x02\x1D\x03\x1C\x04\e\x05\x1A\x06\x19\a\x18\b\x17\t\x16\n\x15\v\x14\f\x13\r\x12\x0E\x11\x0F\x10"
    iv = "\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF"
    plain = algo_decrypt('aes-256-cbc', msg: passwd.hex2ascii, key: key, iv: iv, padding: 0)
    plain = plain.encode('utf-8','utf-16le').delete("\0")
    plain if plain&.printable?
  }
end
