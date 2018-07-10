#!/usr/bin/env ruby
#
# Plugin md5_my_addr
# Author L
#

plugin 'md5_my_addr' do 
  web_server 'http://md5.my-addr.com'
  supported_algorithm :md5

  crack {
    r = post "/md5_decrypt-md5_cracker_online/md5_decoder_tool.php", {md5: passwd}
    extract(r.body, /Hashed string<\/span>: (.*?)<\/div>/)
  }
end

