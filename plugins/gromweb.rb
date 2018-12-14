#!/usr/bin/env ruby
#
# Plugin gromweb
# Author L
#

plugin 'gromweb' do 
  web_server 'http://md5.gromweb.com'
  supported_algorithm :md5

  crack {
    r = get '/', {'md5': passwd}
    r.body.extract(/<em class="long-content string">(.*?)<\/em>/) if r.body['succesfully reversed']
  }
end

