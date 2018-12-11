#!/usr/bin/env ruby
#
# pwcrack updatedb
# Author L
#

module CLI
  using Rainbow

  def self.updatedb(word_file)
    puts "[*] Start creating the local DB...".bold
    puts

    hashs = {
      :md5    => {},
      :sha1   => {},
      :mysql  => {},
    }
    begin 
      require 'mysql_make_scrambled_password'
    rescue LoadError
      puts "[*] Need to support MySQL hash: `gem install mysql_make_scrambled_password`"
      hashs.delete :mysql
    end
    
    words = open(word_file).each(chomp:true).to_a
    words.each_with_index do |word, i|
      hashs.keys.each do |algo|
        case algo
        when :md5
          hashs[algo][ OpenSSL::Digest::MD5.digest(word)[4,8] ] = i
          # md5(unicode)
          hashs[algo][ OpenSSL::Digest::MD5.digest(word.encode('utf-16le'))[4,8] ] = i
        when :sha1
          hashs[algo][ OpenSSL::Digest::SHA1.digest(word)[5,10] ] = i
        when :mysql
          mysql_hash = MysqlMakeScrambledPassword.make_scrambled_password(word)
          hashs[algo][ [mysql_hash[1..-1]].pack('H*')[5,10] ] = i
        end
      end
    end

    db_dir = "#{ROOT}/data/db"
    Dir.mkdir db_dir unless Dir.exist? db_dir

    dump_obj = lambda do |name, obj|
      filename = "#{db_dir}/#{name}.bin"
      open(filename, 'wb') do |f|
        Marshal.dump(obj, f)
      end
    end

    dump_obj.call("words", words)
    puts "[+] local `#{'words'.bold}` db (#{words.size}) : data/db/#{name}.bin"

    hashs.each do |algo, obj|
      name = "`#{algo}`".center 7
      dump_obj.call(algo, obj)
      puts "[+] local #{name.bold} db (#{obj.size}) : data/db/#{algo}.bin"
    end

    exit
  end
end
