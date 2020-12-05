#!/usr/bin/env ruby
#
# Plugin uportal2800
# Author L
#

plugin 'uportal2800' do 
  supported_algorithm :uportal2800

  crack {
    ciphertext = passwd.hex2ascii
    # uportal2800 2015
    plaintext = algo_decrypt(
      'aes-128-cbc',
      key: '76D7427F354BE35E602A5A20D28E408C'.hex2ascii,
      msg: ciphertext
    )

    if plaintext.printable?
      plaintext
    else
      # uportal2800 2016
      iv = ciphertext[-16..-1]
      ciphertext = ciphertext[0, ciphertext.size - 16]
      next if ciphertext.empty?
      %w[
        740636FF64AC046A1EF355A5D652EEF8
        76D7427F354BE35E602A5A20D28E408C
        26A1C12306B4067D136E2929AA18DEB7
        1BCA70F5F75FCD5D8EB3249EEAB029D3
      ].each do |key|
        plaintext = algo_decrypt(
          'aes-128-cbc',
          key: key.hex2ascii,
          iv: iv,
          msg: ciphertext
        )
        break if plaintext.printable?
      end
      plaintext if plaintext.printable?
    end
  }
end

