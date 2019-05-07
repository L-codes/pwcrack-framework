#!/usr/bin/env ruby
#
# Plugin cmd5la
# Author L
#

plugin 'cmd5la' do 
  web_server 'https://cmd5.la/'
  supported_algorithm :md5_16, :md5

  crack {
    enum_algorithm do |algorithm|
      hash = if algorithm == :md5
               passwd[8,16]
             else
               passwd
             end
      r = get "/#{hash}.htm"
      r.body.force_encoding 'utf-8'
      r.body.extract(/解密后明文为:(.+?)</)
    end
  }
end

