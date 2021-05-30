#!/usr/bin/env ruby
#
# Plugin FineReport privilege.xml password decrypt
# Author L
#

plugin 'finereport' do 
  supported_algorithm :finereport

  crack {
    pass_mask = [19, 78, 10, 15, 100, 213, 43, 23].cycle
    plain = passwd.hex2bytes.each_slice(2).map{|_, c| c ^ pass_mask.next }.pack 'C*'
    plain if plain.printable?
  }
end

