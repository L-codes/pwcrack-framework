#!/usr/bin/env ruby
#
# Plugin TRSWCM database decrypt
# Author L
#
# WEB-INF/classes/trsconfig/domain/config.xml
#

plugin 'trswcm' do 
  supported_algorithm :trswcm

  crack {
    plain = passwd.unpack1 'm0'
    plain if plain.printable?
  }
end

