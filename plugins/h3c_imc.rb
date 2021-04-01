#!/usr/bin/env ruby
#
# Plugin h3c_imc mssql database decrypt
# Author L
#

plugin 'h3c_imc' do 
  supported_algorithm :h3c_imc

  crack {
    plain = passwd
      .split('-')
      .each_with_index
      .map{|c, i|  (c.to_i + i * 16) % 256 }
      .pack('C*')
    plain if plain.delete_suffix! '~~'
  }
end

