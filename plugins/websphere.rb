#!/usr/bin/env ruby
#
# Plugin websphere {xor}
# Author L
#
# common: server.xml ws-security.xml security.xml
#

plugin 'websphere' do 
  supported_algorithm :websphere

  crack {
    plaintext = passwd.hex2bytes.map{|x| x ^ 95 }.pack 'C*'
    plaintext if plaintext.printable?
  }
end

