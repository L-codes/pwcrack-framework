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
    des.update(msg) + (des.final rescue '')
  end

  def aes_decrypt(mode: :CBC, key:, msg:, iv:nil)
    aes = OpenSSL::Cipher::AES256.new(mode)
    aes.decrypt
    aes.key = key
    aes.iv = iv if iv
    aes.update(msg) + (aes.final rescue '')
  end

  def md5(msg)
    md5 = OpenSSL::Digest::MD5.new
    md5.hexdigest msg
  end
end
