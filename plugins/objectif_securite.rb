#!/usr/bin/env ruby
#
# Plugin objectif_securite
# Author L
#

plugin 'objectif_securite' do 
  web_server 'https://cracker.okx.ch:8443'
  supported_algorithm :ntlm

  crack {
    data = {"value": passwd}
    r = post_json '/crack', data
    if r.body !~ /Password not found| ?queue\.? /i
      r.body.extract(/"msg":"(.+?)"/)
    end
  }
end

