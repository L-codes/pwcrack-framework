#!/usr/bin/env ruby
#
# Crypto Library
# Author L
#
require 'openssl'
require_relative 'crypto/d3des'

module Crypto

  def algo_decrypt(algo, key:, msg:, key_len: nil, iv:nil, padding: nil)
    cipher = OpenSSL::Cipher.new(algo)
    cipher.decrypt
    cipher.key_len = key_len if key_len
    cipher.key = key
    cipher.iv = iv if iv
    cipher.padding = padding if padding
    cipher.update(msg) + (cipher.final rescue '')
  end

  def algo_encrypt(algo, key:, msg:, key_len: nil, iv:nil, padding: nil)
    cipher = OpenSSL::Cipher.new(algo)
    cipher.encrypt
    cipher.key_len = key_len if key_len
    cipher.key = key
    cipher.iv = iv if iv
    cipher.padding = padding if padding
    cipher.update(msg) + (cipher.final rescue '')
  end

  def rc4_decrypt(key:, msg:)
    rc4 = OpenSSL::Cipher::RC4.new
    rc4.key = key
    rc4.update(msg) + (rc4.final rescue '')
  end

  alias :rc4_encrypt :rc4_decrypt

  [:md5, :sha1, :sha256].each do |method|
    define_method method do |msg|
      OpenSSL::Digest.new(method.to_s).digest(msg)
    end

    define_method "#{method}_hex" do |msg|
      OpenSSL::Digest.new(method.to_s).hexdigest(msg)
    end
  end

end
