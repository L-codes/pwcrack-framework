#!/usr/bin/env ruby
#
# Plugin juniper_type9
# Author L
#
# encrypt: https://www.m00nie.com/juniper-type-9-password-tool/

plugin 'juniper_type9' do 
  supported_algorithm :juniper_type9

  crack {
    Family = ["QzF3n6/9CAtpu0O", "B1IREhcSyrleKvMW8LXx", "7N-dVbwsY2g4oaJZGUDj", "iHkq.mPf5T"]
    Extra = Hash.new.tap do |h|
      Family.each_with_index do |item, i|
        item.each_char.each {|c| h[c] = 3 - i}
      end
    end

    NumAlpha = Family.join.chars
    AlphaNum = NumAlpha.each_with_index.to_h

    ENCODING = [[1, 4, 32], [1, 16, 32], [1, 8, 32], [1, 64], [1, 32], [1, 4, 16, 128], [1, 32, 64]]

    def nibble(cref, length)
      nib = cref[0, length]
      rest = cref[length..-1]
      [nib, rest]
    end

    def gap(c1, c2)
      (AlphaNum[c2] - AlphaNum[c1]) % NumAlpha.size - 1
    end

    def gap_decode(gaps, dec)
      num = gaps.size.times.map{|x| gaps[x] * dec[x]}.sum
      num % 256
    end

    def juniper_decrypt(cipher)
      cipher = cipher[3..-1]
      first, cipher = nibble(cipher, 1)
      toss, cipher = nibble(cipher, Extra[first])
      prev = first
      decrypt = ""
      until cipher.empty?
        decode = ENCODING[decrypt.size % ENCODING.size]
        nnibble, cipher = nibble(cipher, decode.size)
        return nil if cipher.nil?
        gaps = []
        nnibble.each_char do |i|
          g = gap(prev, i)
          prev = i
          gaps << g
        end
        return nil if gaps.size != decode.size
        decrypt << gap_decode(gaps, decode)
      end
      decrypt
    end

    juniper_decrypt(passwd)
  }
end

