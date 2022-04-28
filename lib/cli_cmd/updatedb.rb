#!/usr/bin/env ruby
#
# pwcrack updatedb
# Author L
#

module CLI
  using Rainbow

  def self.updatedb(word_file)
    start = Time.now
    puts "[*] Start update the local DB...".white
    puts

    load_obj = ->(file) {
      if File.exist? file
        MessagePack.unpack(File.binread(file))
      else
        abort 'Please initialize the local database: pwcrack updatedb'
      end
    }

    hashes = {}

    md4  = OpenSSL::Digest::MD4.new
    md5  = OpenSSL::Digest::MD5.new
    sha1 = OpenSSL::Digest::SHA1.new
    des  = OpenSSL::Cipher::DES.new
    des.encrypt

    lm_magic = "KGS!@\#$%"

    old_words = load_obj.call("#{ROOT}/data/db/words.bin")
    words = File.readlines(word_file, chomp:true) - old_words
    old_size = old_words.size

    if words.size > 0
      puts "[*] Add record: #{words.size}"
      puts
    else
      puts '[!] No new records found'
      exit 
    end

    %i(md5 md5x2 md5x3 sha1 mysql ntlm lm).each do |algo|
      file = "#{ROOT}/data/db/#{algo}.bin"
      hashes[algo] = load_obj.call(file)
    end

    progressbar = ProgressBar.create(
      :title  => 'Progress',
      :format => ' %t: |%E |%b>%i|%j%%',
      :total  => 100,
      :length => 75,
    )
    n = words.size / 99
    n = 1 if n.zero?

    words.each_with_index do |word, i|
      i += old_size

      sha1b = sha1.digest(word)
      md5_1 = md5.digest(word)
      md5_2 = md5.digest(md5_1)
      md5_3 = md5.hexdigest(md5_2)
      md5_1_hex = md5_1.unpack1('H*')
      md5_2_hex = md5.hexdigest(md5_1_hex)
      md5_3_hex = md5.hexdigest(md5_2_hex)
      md5_1_hex_up = md5_1_hex.upcase
      md5_2_hex_up = md5.hexdigest(md5_1_hex_up).upcase
      md5_3_hex_up = md5.hexdigest(md5_2_hex_up)

      hashes.keys.each do |algo|
        case algo
        when :ntlm
          # ntlm = md4(unicode)
          hashes[algo][ md4.hexdigest(word.encode('utf-16le'))[8,16].hex2int ] = i
        when :md5
          hashes[algo][ md5_1[4,8].bytes2int ] = i
          # md5(unicode)
          hashes[algo][ md5.hexdigest(word.encode('utf-16le'))[8,16].hex2int ] = i
        when :md5x2
          hashes[algo][ md5_2[4,8].bytes2int ] = i
          hashes[algo][ md5_2_hex[8,16].hex2int ] = i
          hashes[algo][ md5_2_hex_up[8,16].hex2int ] = i
        when :md5x3
          hashes[algo][ md5_3[8,16].hex2int ] = i
          hashes[algo][ md5_3_hex[8,16].hex2int ] = i
          hashes[algo][ md5_3_hex_up[8,16].hex2int ] = i
        when :sha1
          hashes[algo][ sha1b[5,8].bytes2int ] = i
        when :mysql
          mysql_hash = sha1.hexdigest(sha1b)
          hashes[algo][ mysql_hash[10,16].hex2int ] = i
        when :lm
          if word.size <= 14
            str_to_key = -> (s){
              a = s.unpack1('H*').to_i(16) << 7
              b = 0b1111111
              r = 16.times.map {
                a >>= 7
                (a & b) << 1
              }
              r.reverse.pack('C*')
            }

            begin
              key = str_to_key[ word.upcase.encode('ISO-8859-1').ljust(14, "\x00") ]
            rescue
              next
            end


            h = ''
            des.reset
            des.key = key[0,8]
            h += des.update(lm_magic)
            des.reset
            des.key = key[8,8]
            h += des.update(lm_magic)

            hashes[algo][ h[4,8].bytes2int ] = i
          end
        end
      end

      progressbar.increment if (i - old_size) % n == 1
    end
    progressbar.finish

    db_dir = "#{ROOT}/data/db"
    Dir.mkdir db_dir unless Dir.exist? db_dir

    dump_obj = lambda do |name, obj|
      filename = "#{db_dir}/#{name}.bin"
      begin
        File.binwrite(filename, MessagePack.pack(obj))
      rescue Errno::EACCES
        abort "[!] Save #{filename} Errno::EACCES"
      end
      msize = File.size(filename).to_f / 1024 / 1024
      algo = "#{name}".center 7

      puts "[+] %s db (%7s) : [%4.1fM] data/db/%s.bin" % [algo.bold, obj.size, msize, name]
      msize
    end

    puts
    puts '[*] Update Database...'
    hashes['words'] = old_words + words
    count = hashes.sum { |algo, obj|
      dump_obj.call(algo, obj)
    }
    msize = '%4.1fM'.bold % count
    puts "[*] Database total storage:  #{msize}"

    seconds = Time.now - start
    puts
    puts "[*] PWCrack update local DB in #{'%.2f'.bold} seconds.".white % seconds
    exit
  end

end
