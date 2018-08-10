#!/usr/bin/env ruby
#
# Crypto Library
# Author L
#

require 'openssl'

module Crypto
  def des_decrypt(mode:, key:, msg:, iv:nil)
    des = OpenSSL::Cipher::DES.new(mode)
    des.decrypt
    des.key = key
    des.iv = iv if iv
    des.update(msg)
  end

  def md5(msg)
    md5 = OpenSSL::Digest::MD5.new
    md5.hexdigest msg
  end
end
