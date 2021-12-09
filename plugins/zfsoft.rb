#!/usr/bin/env ruby
#
# Plugin zfsoft
# Author L
#

plugin 'zfsoft' do 
  supported_algorithm :zfsoft

  crack {
    keys = %w{ Encrypt01 Acxylf365jw jwc01 }
    plain = false
    middle = passwd.size / 2
    pass_bytes = passwd.bytes
    pass_bytes = pass_bytes[0...middle].reverse + pass_bytes[middle..-1].reverse
    keys.each do |key|
      key = key.each_byte.cycle
      plain_bytes = pass_bytes.map{|c|
        xor = c ^ key.next
        (32..126).include?(xor) ? xor : c
      }
      if plain_bytes.pack('C*').printable?
        plain = plain_bytes.pack('C*')
        break
      end
    end
    plain
  }
end

