#!/usr/bin/env ruby
#
# Plugin h3c_huawei
# Author L
#

plugin 'h3c_huawei' do 
  supported_algorithm :h3c_huawei

  crack {
    #s_enum_byte = passwd.each_byte.map{ |x| (x == ?a.ord ? ??.ord : x) - ?!.ord }
    s_enum_byte = passwd.each_byte.map{ |x| (x == 97 ? 63 : x) - 33 }

    out = Array.new(18, 0)
    i = 0
    s_enum_byte.each_slice(4) do |a, b, c, d|
      y = a
      y = (y << 6) & 0xffffff

      y = (y | b)  & 0xffffff
      y = (y << 6) & 0xffffff

      y = (y | c)  & 0xffffff
      y = (y << 6) & 0xffffff

      y = (y | d)  & 0xffffff

      out[i + 2] = y         & 0xff
      out[i + 1] = (y >> 8)  & 0xff
      out[i + 0] = (y >> 16) & 0xff

      i += 3
    end
    ciphertext = out[0,16].pack 'C*'

    key = "\x01\x02\x03\x04\x05\x06\x07\x08"
    plaintext = algo_decrypt('des-cbc', msg: ciphertext, key: key)
    plaintext if plaintext.printable?
  }
end

