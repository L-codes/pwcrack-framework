#!/usr/bin/env ruby
#
# Plugin localdb
# Author L
#
# 查询本地data/db/*.bin的数据库文件(收集了53W的收费hash)

plugin 'localdb' do 
  supported_algorithm :md5, :md5_16, :sha1, :mysql

  crack {
    enum_algorithm do |algorithm|
      name = algorithm
      case algorithm
      when :md5
        key = passwd.hex2ascii[4,8]
      when :md5_16
        key = passwd.hex2ascii
      when :sha1
        key = passwd.hex2ascii[5,10]
      when :mysql
        key = passwd.hex2ascii[5,10]
      end

      file = "#{ROOT}/data/db/#{name}.bin"
      hash = Marshal.load(open(file, 'rb'))
      hash[key]
    end
  }
end

