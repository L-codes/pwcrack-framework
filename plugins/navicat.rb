#!/usr/bin/env ruby
#
# Plugin navicat
# Author L
#

plugin 'navicat' do 
  supported_algorithm :navicat11, :navicat12

  crack {
    enum_algorithm do |algorithm|
      case algorithm
      when :navicat11
        cipher = passwd.hex2ascii
        key = sha1('3DC5CA39')
        current_iv = 'd9c7c3c8870d64bd'.hex2ascii
        div, mod = cipher.size.divmod 8
        plaintext = ''
        div.times do |i|
          block = cipher[i*8, 8]
          plaintext += algo_decrypt('bf-ecb', msg: block, key: key, key_len: key.size) ^ current_iv
          current_iv ^= block
        end
        if mod != 0
          current_iv = algo_encrypt('bf-ecb', key: key, key_len: key.size, msg: current_iv)
          plaintext += cipher[(-mod)..-1] ^ current_iv
        end
        plaintext if plaintext.printable?

      when :navicat12
        cipher = passwd.hex2ascii
        key = 'libcckeylibcckey'
        iv  = 'libcciv libcciv '
        plaintext = algo_decrypt('aes-128-cbc', msg: cipher, key: key, iv: iv, padding: 0)

        # unpadding
        len = plaintext.size - plaintext[-1].ord
        plaintext = plaintext[0, len]
        plaintext if plaintext.printable?
      end
    end
  }
end

