#!/usr/bin/env ruby
#
# Javascript External
# Author L
#


begin
	require 'execjs'
rescue LoadError
  puts  '[*] Lack of dependent libraries.'
  abort '[-] Please execute: gem install execjs'
end


module JS
  def js_require(name)
    file = "#{ROOT}/external/javascript/#{name}"
    code = File.read file
    ExecJS.compile(code)
  rescue Errno::ENOENT
    abort "[!] File not found: #{file}"
  end

  def js_eval(code)
    ExecJS.eval(code)
  end
end

