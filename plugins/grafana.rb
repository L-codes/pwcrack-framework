#!/usr/bin/env ruby
#
# Plugin grafana
# /var/lib/grafana/grafana.db data_source json_crypto
# Author L
#

plugin 'grafana' do 
  supported_algorithm :grafana

  crack {

    key = "SW2YcwTIb9zpOOhoPsMm"
    cipher = passwd.hex2ascii
    if cipher.start_with? '*'
      salt, iv, cipher = cipher[1..-1].unpack('a8a12a*')
      algo = 'aes-256-gcm'
    else
      salt, iv, cipher = cipher.unpack('a8a16a*')
      algo = 'aes-256-cfb'
    end
    key = OpenSSL::PKCS5.pbkdf2_hmac key, salt, 10000, 32, 'sha256'
    plain = algo_decrypt(algo, msg: cipher, key: key, iv: iv)
    plain if plain.printable?
  }
end

