#!/usr/bin/env ruby
#
# Plugin pmd5
# Author L
#

plugin 'pmd5' do 
  web_server 'http://pmd5.com'
  supported_algorithm :md5, :md5_16

  crack {
		r = get '/'
    unless r.body.empty?
      info = Hash[r.body.scan(/id="(__[\w]+)" value="(.*?)"/)]
			data = {"__VIEWSTATE": info["__VIEWSTATE"], "__EVENTVALIDATION": info["__EVENTVALIDATION"],
							"__VIEWSTATEGENERATOR": info["__VIEWSTATEGENERATOR"],
							"key": passwd, "jiemi": "MD5\u89e3\u5bc6"}
      r = post('/', data)
      extract(r.body, /#{passwd}(?:.*?)<em>(.+?)<\/em>/)
    end
  }
end

