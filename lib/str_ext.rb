#!/usr/bin/env ruby
# 
# String Class Extend
# Author L
#

class String

  def extract(regexp, place = 1)
    m = self.match(regexp)
    m[place] if m
  end

  def printable?
    self.b.match? /\A\p{Print}+\z/n
  end

  def hex2ascii
    [self].pack('H*')
  end

  def hex2bytes
    hex2ascii.bytes
  end

  def hex2int
    to_i(16)
  end

  def bytes2int
    unpack1('H*').to_i(16)
  end

  def ishex?
    self.match? /(^([a-f0-9]{2})+$)|(^([A-F0-9]{2})+$)/
  end
end
