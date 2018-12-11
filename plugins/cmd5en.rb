#!/usr/bin/env ruby
#
# Plugin cmd5en
# Author L
#
# 为cmd5的英文版, 用于解决国外访问需要验证码的问题

plugin 'cmd5en' do 
  web_server 'https://www.cmd5.org'
  supported_algorithm :md4, :md5, :md5_16, :sha1, :sha256, :sha512, :ntlm, :mysql3, :mysql

  # TODO 添加账号，支持Unix密码查询
  crack {
		r = get '/'
    unless r.body.empty?
      info = Hash[r.body.scan(/id="(.+?)" value="(.*?)"/)]
      data = {"__EVENTTARGET": info["__EVENTTARGET"],
              "__EVENTARGUMENT": info["__EVENTARGUMENT"],
              "__VIEWSTATE": info["__VIEWSTATE"],
              "__VIEWSTATEGENERATOR": info["__VIEWSTATEGENERATOR"],
              "ctl00$ContentPlaceHolder1$TextBoxInput": passwd,
              "ctl00$ContentPlaceHolder1$InputHashType": "md5",
              "ctl00$ContentPlaceHolder1$Button1": "\u67e5\u8be2",
              "ctl00$ContentPlaceHolder1$HiddenField1": "",
              "ctl00$ContentPlaceHolder1$HiddenField2": info["ctl00_ContentPlaceHolder1_HiddenField2"]}
      r = post('/', data, {'referer': web_server_url})

      case r.body
      when /Found.But this is a payment record/
        raise Chargeable
      when /Not Verified!|Please log in/
        raise VerificationCodeError
      else
        regexp = /id="ctl00_ContentPlaceHolder1_LabelAnswer">(.+?)<\/span>/m
        r.body.extract(regexp)&.gsub(/<.*?>/, '') if r.body !~ /Not Found/
      end
    end
  }
end
