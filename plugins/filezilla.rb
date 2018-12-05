#!/usr/bin/env ruby
#
# Plugin filezilla
# Author L
#
# PassFile: FileZilla\FileZilla.xml
# Password base64: C:\Users\<User>\AppData\Roaming\FileZilla\sitemanager.xml
#

plugin 'filezilla' do 
  supported_algorithm :filezilla

  crack {
    array = passwd.scan(/.{3}/).map(&:to_i)
    key = 'FILEZILLA1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'.bytes

    pos = array.size % key.size
    array.each_with_index do |val, index|
      k = key[ (index + pos) % key.size ]
      array[index] = val ^ k
    end

    r = array.pack 'C*'
    r if r.printable?
  }
end




