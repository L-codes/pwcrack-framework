#!/usr/bin/env ruby
#
# Plugin signer
# example: eyJhbGciOiJIUzI1NiJ9.ImV0MkAyNiI.4YdYIfSARygmqssF7FYT0P-kJCctMdtK4_B6atrTeWE
#      to: {"alg":"HS256"}.password.hash
#

plugin 'signer' do 
  supported_algorithm :signer

  crack {
    plain = passwd.split('.')[1].unpack1('m').undump
    plain if plain&.printable?
  }
end
