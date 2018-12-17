#!/usr/bin/env ruby
#
# pwcrack add
# Author L
#

module CLI

  def self.add(add_words)
    default_word = "#{ROOT}/data/words.txt"
    words = open(default_word).each(chomp:true).to_a
    puts "[+] old: #{words.size}"
    words = (words + add_words).uniq
    puts "[+] new: #{words.size}"
    File.binwrite(default_word, words.join("\n"))
    exit
  end
end


