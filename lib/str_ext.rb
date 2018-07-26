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
    self.match? /^\p{ASCII}+$/
  end

  def hex2bytes
    [self].pack('H*').bytes
  end

end
