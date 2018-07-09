#!/usr/bin/env ruby
#
# Plugin objectif_securite
# Author L
# Date   2018-06-28
#

plugin 'objectif_securite' do 
  web_server 'https://www.objectif-securite.ch'
  supported_algorithm :ntlm

  crack {
    data = {"value": passwd}
    r = post_json '/demo.php/crack', data
    if r.body !~ /Password not found|queue/
      extract(r.body, /"msg":"(.+?)"/)
    end
  }
end

