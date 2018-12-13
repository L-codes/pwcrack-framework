#!/usr/bin/env ruby
#
# pwcrack updatedb
# Author L
#

module CLI
  using Rainbow

  def self.updatedb(word_file)
    start = Time.now
    puts "[*] Start creating the local DB...".white
    puts

    hashs = {
      :md5   => {},
      :md5x2 => {},
      :md5x3 => {},
      :sha1  => {},
      :mysql => {},
    }

    begin 
      require 'mysql_make_scrambled_password'
    rescue LoadError
      puts "[*] Need to support MySQL hash: `gem install mysql_make_scrambled_password`"
      hashs.delete :mysql
    end
    
    md5 = OpenSSL::Digest::MD5.new
    sha1 = OpenSSL::Digest::SHA1.new
    words = open(word_file).each(chomp:true).to_a

    words.each_with_index do |word, i|

      md5_1 = md5.digest(word)
      md5_2 = md5.digest(md5_1)
      md5_3 = md5.hexdigest(md5_2)
      md5_1_hex = md5_1.unpack1('H*')
      md5_2_hex = md5.hexdigest(md5_1_hex)
      md5_3_hex = md5.hexdigest(md5_2_hex)
      md5_1_hex_up = md5_1_hex.upcase
      md5_2_hex_up = md5.hexdigest(md5_1_hex_up).upcase
      md5_3_hex_up = md5.hexdigest(md5_2_hex_up)

      hashs.keys.each do |algo|
        case algo
        when :md5
          hashs[algo][ md5_1[4,8].bytes2int ] = i
          # md5(unicode)
          hashs[algo][ md5.hexdigest(word.encode('utf-16le'))[8,16].hex2int ] = i
        when :md5x2
          hashs[algo][ md5_2[4,8].bytes2int ] = i
          hashs[algo][ md5_2_hex[8,16].hex2int ] = i
          hashs[algo][ md5_2_hex_up[8,16].hex2int ] = i
        when :md5x3
          hashs[algo][ md5_3[8,16].hex2int ] = i
          hashs[algo][ md5_3_hex[8,16].hex2int ] = i
          hashs[algo][ md5_3_hex_up[8,16].hex2int ] = i
        when :sha1
          hashs[algo][ sha1.hexdigest(word)[10,16].hex2int ] = i
        when :mysql
          mysql_hash = MysqlMakeScrambledPassword.make_scrambled_password(word)
          hashs[algo][ mysql_hash[11,16].hex2int ] = i
        end
      end
    end

    db_dir = "#{ROOT}/data/db"
    Dir.mkdir db_dir unless Dir.exist? db_dir

    dump_obj = lambda do |name, obj|
      filename = "#{db_dir}/#{name}.bin"
      File.binwrite(filename, MessagePack.pack(obj))
      algo = "`#{name}`".center 7
      puts "[+] local #{algo.bold} db (#{obj.size.to_s.rjust(7)}) : data/db/#{name}.bin"
    end

    hashs['words'] = words
    hashs.each do |algo, obj|
      dump_obj.call(algo, obj)
    end

    seconds = Time.now - start
    puts
    puts "[*] PWCrack creating local DB in #{'%.2f'.bold} seconds.".white % seconds
    exit
  end

end
