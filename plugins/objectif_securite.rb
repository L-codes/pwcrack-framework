#!/usr/bin/env ruby
#
# Plugin objectif_securite
# Author L
#

plugin 'objectif_securite' do 
  web_server 'https://www.objectif-securite.ch'
  supported_algorithm :ntlm

  crack {
    data = {"value": passwd}
    r = post_json '/demo.php/crack', data
    if r.body !~ /Password not found|Queue is full|Hash added to queue/
      r.body.extract(/"msg":"(.+?)"/)
    end
  }
end

