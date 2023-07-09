#!/usr/bin/env ruby
#
# Plugin finalshell password decrypt
# Author L
# Reference https://github.com/jas502n/FinalShellDecodePass
#
# ~/Library/FinalShell/conn/xxxxxx/xxxxxx_connect_config.json
#

if Kernel.const_defined? :Rjb

plugin 'finalshell' do 
  supported_algorithm :finalshell

  crack {
    cipher = [passwd.hex2ascii].pack 'm0'
    plain = Rjb.import('com.finalshell.FinalShellDecodePass').decodePass(cipher)
    plain if plain.printable?
  }
end

end
