
#!/usr/bin/env ruby
#
# Plugin SecureCRT Password
# Author L
# PATH: %AppData%/Roaming/VanDyke/Config/Sessions/
# 

plugin 'securecrt' do 
  supported_algorithm :securecrt, :securecrt_v2

  crack {
    ciphertext = [passwd].pack 'H*'
    enum_algorithm do |algorithm|
      case algorithm
      when :securecrt
        key1 = ['5FB045A29417D916C6C6A2FF064182B7'].pack 'H*'
        key2 = ['24A63DDE5BD3B3829C7E06F40816AA07'].pack 'H*'
        bytes = algo_decrypt('blowfish', key: key2, msg: ciphertext, padding: 0)[4...-4]
        algo_decrypt('blowfish', key: key1, msg: bytes, padding: 0)
          .encode('utf-8', 'utf-16le')
          .split("\0")
          .first
      when :securecrt_v2
        bytes = algo_decrypt('aes-256-cbc', key: sha256(''), msg: ciphertext, padding: 0)
        plaintext_length = bytes.unpack1 'l'
        plaintext = bytes[4, plaintext_length]
        sha256_hash = bytes[4+plaintext_length, 32]
        if plaintext_length == plaintext.size and sha256(plaintext) == sha256_hash
          plaintext
        end
      end
    end
  }
end

