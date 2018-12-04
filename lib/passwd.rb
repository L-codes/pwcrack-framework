#!/usr/bin/env ruby
# 
# Password Algorithm Analysis Library
# Author L
#

module PasswdLib
  Passwd = Struct.new(:cipher, :algos)

  def passwd_analysis(passwd, algorithms, quiet)
    @quiet = quiet
    find_hash_type(passwd)
    abort 'No ciphertext algorithm found' if passwd.algos == [:unkown]

    unless algorithms.empty?
      passwd.algos &= algorithms.map(&:to_sym)
      abort "Password is not a #{algorithms.map(&:upcase).join(' or ')} algorithm" if passwd.algos.empty?
    end
    passwd.cipher = passwd.cipher.downcase if (passwd.algos & [:juniper_type9, :h3c_huawei]).size > 1
  end

  def base64_to_hex(base64code)
    bytes = Base64.decode64 base64code
    # Automatically identify hex and bytes
    bytes.strip.ishex? ? bytes.strip : bytes.unpack1('H*')
  end

  def find_hash_type(passwd)
    cipher = passwd.cipher
    algorithms = []

    prefixs = /^(base64|hex):/i
    if cipher =~ prefixs
      cipher = cipher.sub prefixs, ''
      case $1
      when /base64/i
        cipher = base64_to_hex(cipher)
        algorithms << :gpp
      when /hex/i
        cipher = cipher.gsub /\H/, ''
      end
      puts "[*] Hash: #{cipher}" unless @quiet
    end

    algorithms += Array(
      case cipher
      when /(^([a-f0-9]{2})+$)|(^([A-F0-9]{2})+$)/
        types = case cipher.size
                when 16
                  [:md5_16, :mysql3]
                when 32
                  [:md5, :md4, :lm, :ntlm]
                when 40
                  [:sha1, :mysql, :ripemd160]
                when 56
                  :sha224
                when 64
                  :sha256
                when 96
                  :sha384
                when 128
                  [:sha512, :whirlpool]
                end
        types = Array(types) + [:foxmail, :foxmail6]
        if cipher.size > 2 and cipher[0,2].to_i(16) <= 50
          types = Array(types) << :cisco_type7
        end
        if cipher.size > 80
          types = Array(types) << :cisco_vpn
        end
        types
      when /^\*([a-f0-9]{40}|[A-F0-9]{40})$/
        cipher = cipher.delete_prefix '*'
        :mysql
      when /^\$9\$/
        :juniper_type9
      when /^\p{ASCII}{24}$/
        :h3c_huawei
      when /(^([a-f0-9]{2})+!$)|(^([A-F0-9]{2})+!$)/
        cipher = cipher.delete_suffix '!'
        :foxmail
      when /^[a-z]{2}([A-F0-9]{2}){16}/
        # hash = salt + md5(salt+password).upcase
        :serv_u
      else
        :unkown
      end
    )
    algorithms << :filezilla if cipher.scan(/.{3}/).all?{|n| n.to_i <= 127}
    passwd.algos = algorithms
    passwd.cipher = cipher
  end
end
