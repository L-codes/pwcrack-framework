#!/usr/bin/env ruby
#
# Plugin h3c_cvm mysql database `vservice.TBL_OPERATOR password` decrypt
# Author L
#

plugin 'h3c_cvm' do 
  supported_algorithm :h3c_cvm

  crack {
    plain = algo_decrypt 'des-ecb', key: 'li_01010', msg: passwd.hex2ascii
    plain if plain.printable?
  }
end

