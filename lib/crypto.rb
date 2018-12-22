#!/usr/bin/env ruby
#
# Crypto Library
# Author L
#

module Crypto

  def algo_decrypt(algo, key:, msg:, iv:nil)
    aes = OpenSSL::Cipher.new(algo)
    aes.decrypt
    aes.key = key
    aes.iv = iv if iv
    aes.update(msg) + (aes.final rescue '')
  end

  def algo_encrypt(algo, key:, msg:, iv:nil)
    aes = OpenSSL::Cipher.new(algo)
    aes.encrypt
    aes.key = key
    aes.iv = iv if iv
    aes.update(msg) + (aes.final rescue '')
  end

  [:md5, :sha1].each do |method|
    define_method method do |msg|
      OpenSSL::Digest.new(method.to_s).digest(msg)
    end

    define_method "#{method}_hex" do |msg|
      OpenSSL::Digest.new(method.to_s).hexdigest(msg)
    end
  end

end
