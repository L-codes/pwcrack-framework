#!/usr/bin/env ruby
# 
# String Class Extend
# Author L
#

class String
  def extract(regexp, place = 1)
    self.match(regexp)
    m[place] if m
  end

  def printable?
    self.match? /^\p{PRINT}+$/
  end
end
