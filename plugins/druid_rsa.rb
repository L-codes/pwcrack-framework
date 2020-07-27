#!/usr/bin/env ruby
#
# Plugin druid rsa
# Author L
#

plugin 'druid_rsa' do 
  supported_algorithm :druid_rsa

  crack {
    ciphertext =  [passwd].pack 'H*'
    pubkey = "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKHGwq7q2RmwuRgKxBypQHw0mYu4BQZ3eMsTrdK8E6igRcxsobUC7uT0SoxIjl1WveWniCASejoQtn/BY6hVKWsCAwEAAQ==".unpack1('m0')
    rsa = OpenSSL::PKey::RSA.new pubkey
    plaintext = rsa.public_decrypt(ciphertext)
    plaintext if plaintext.printable?
  }
end

