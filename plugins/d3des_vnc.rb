#!/usr/bin/env ruby
#
# Plugin d3des_vnc
# Author L
#
# Ref: https://github.com/rm1984/VNCpwd
# ~/.vnc/passwd
#

plugin 'd3des_vnc' do 
  supported_algorithm :d3des_vnc

  crack {
    vnckey = [ 23,82,107,6,35,78,88,7 ].pack 'C*'
    hash = passwd.hex2ascii

    des_key = Crypto::D3DES.deskey(vnckey, true)

    pd = hash.each_char.each_slice(8).map { |block|
      block = block.join.ljust 8, "\0"
      pd = Crypto::D3DES.desfunc(block, des_key)
      pd.gsub(/\0+$/, '')
    }.join

    pd if pd.printable?
  }
end

