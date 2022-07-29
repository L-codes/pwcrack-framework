#!/usr/bin/env ruby
#
# Plugin seeyon_analyze_icloud
# Author L
#

plugin 'seeyon_analyze_icloud' do 
  supported_algorithm :seeyon_analyze_icloud

  crack {
    key = 933910847463829827159347601486730416058
    cipher = passwd.hex

    pd = [ (cipher ^ key).to_s(16) ].pack 'H*'
    pd if pd.printable?
  }
end

