#!/usr/bin/env ruby
#
# Plugin qizhi php
# Author L
#
# hash from pg: select secret from server_passwd
#

plugin 'qizhi_php' do 
  supported_algorithm :qizhi_php

  crack {
    if passwd.include?(':')
      cipher = passwd.split(':').last.unpack1 'm0'
    else
      cipher = passwd.hex2ascii
    end
    key = "x\x00?\xC0~\xD0\x86|FE\xFA\xF43\xF0O\x8A"
    plain = algo_decrypt('aes-128-ecb', key: key, msg: cipher, padding: 0)
    len = plain.unpack1('i')
    plain = plain[4, len]
    plain if plain.printable?
  }
end

