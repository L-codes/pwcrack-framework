#!/usr/bin/env ruby
#
# Plugin mac_osx_vnc
# Author L
#
# Hash File: /Library/Preferences/com.apple.VNCSettings.txt
#

plugin 'mac_osx_vnc' do 
  supported_algorithm :mac_osx_vnc

  crack {
    key = '1734516E8BA8C5E2FF1C39567390ADCA'.hex2bytes
    hash = passwd.hex2bytes

    pd = key.zip(hash).map{ |x,y| x ^ y }.pack 'C*'
    pd.delete!("\0")
    pd if pd.printable?
  }
end

