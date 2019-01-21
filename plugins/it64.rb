#!/usr/bin/env ruby
#
# Plugin it64
# Author L
#

plugin 'it64' do 
  web_server 'http://rainbowtables.it64.com'
  supported_algorithm :lm

  crack {
    r = post "/p3.php", "hashe=#{passwd}&ifik=+Submit+&forma=tak"
    result = ''
    # lm = lmhash(0..7) + lmhash(0..7)
    r.body.scan(/&nbsp;(.*?)&nbsp;/).flatten.each_slice(3) do |hash, status, plaintext|
      result << plaintext if status == 'CRACKED'
    end
    result unless result.empty?
  }
end

