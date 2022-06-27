#!/usr/bin/env ruby
#
# Plugin mobaxterm
# Author L
#

plugin 'mobaxterm' do 
  supported_algorithm :mobaxterm

  crack {

    plaintext = nil
    [
      [passwd.hex2ascii].pack('m0'), # add base64: head
      passwd
    ].each do |password|

      key = '0d5e9n1348/U2+67'.chars

      plaintext = password.each_char.filter{ key.include? _1 }.each_slice(2).map{
        x = key.index(_1)
        key.rotate! -1
        y = key.index(_2)
        key.rotate! -1
        y * 16 + x
      }.pack('C*')

      break if plaintext.printable?

    end

    plaintext if plaintext.printable?
  }
end

