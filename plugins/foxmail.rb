#!/usr/bin/env ruby
#
# Plugin foxmail
# Author L
#
# Version >=7.1 : Foxmail 7.2\Storage\<account_emailaddress>\Accounts\Account.rec0
# Version 7.0   : Foxmail 7.0\Data\AccCfg\Accounts.tdat
# Version <6.0  : Foxmail\mail\<account_emailaddress>\Account.stg

plugin 'foxmail' do 
  supported_algorithm :foxmail6, :foxmail

  crack {
    enum_algorithm do |algorithm|
      b = passwd.hex2bytes

      if algorithm == :foxmail6
        key = '~draGon~'.bytes
        fc = 0x5A
      else
        key = '~F@7%m$~'.bytes
        fc = 0x71
      end

      break nil if b.size > 80
      key *= 10
      b[0] ^= fc

      d = []
      (1...b.size).each do |i|
        d[i-1] = b[i] ^ key[i-1]
      end

      r = ''
      d.size.times do |i|
        if d[i] - b[i] < 0
          r << d[i] - b[i] + 255
        else
          r << d[i] - b[i]
        end
      end
      r if r.printable?
    end
  }
end




