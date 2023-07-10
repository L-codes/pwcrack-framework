#!/usr/bin/env ruby
# 
# Password Algorithm Analysis Library
# Author L
#

module PasswdLib
  Algorithms = %w{
    cisco_type7 cisco_vpn dedecms dongao_rc4 druid_rsa filezilla foxmail6
    foxmail gpp h3c_huawei juniper_type9 lm mac_osx_vnc md2 md4 md5
    md5_16 mdc2 mssql mysql3 mysql ntlm ripemd128 ripemd160 ripemd256
    ripemd320 serv_u sha1 sha224 sha256 sha384 sha512 whirlpool xftp
    xshell securecrt securecrt_v2 dahan_jis uportal2800 navicat11 navicat12
    flashfxp lsrunase qizhi_php seeyon_a8 h3c_imc landray_ekp d3des_vnc
    finereport zfsoft grafana trswcm mobaxterm seeyon_analyze_icloud
    richmail signer h3c_cvm seeyon_nc finalshell
  }

  Passwd = Struct.new(:cipher, :algos) do
    def passwd(algorithms)
      if algorithms.include? :dedecms
        cipher[3, 16]
      elsif algorithms.include? :mysql
        cipher.delete_prefix '*'
      elsif algorithms.include? :foxmail
        cipher.delete_suffix '!'
      elsif algorithms.include? :serv_u
        cipher[2..-1].downcase
      else
        cipher
      end
    end
  end

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

    prefixs = Regexp.union(
      /^(base64|hex):/i,
      /^{xor}/,
    )
    if cipher =~ prefixs
      cipher = cipher.sub prefixs, ''
      case $&
      when /base64/i
        if cipher.each_char.filter{ '0d5e9n1348/U2+67'.include? _1 }.size.even?
          algorithms += [:mobaxterm]
        end
        cipher = base64_to_hex(cipher)
        algorithms += [
          :gpp, :dongao_rc4, :druid_rsa, :xshell, :xftp, :dahan_jis, :websphere, :qizhi_php, :seeyon_a8, :landray_ekp,
          :h3c_cvm, :finalshell
        ]
        algorithms << :lsrunase if cipher.size <= 1024
        algorithms << :grafana if cipher.size >= 50 or (cipher.start_with?('2a') and cipher.size >= 44)
      when '{xor}'
        cipher = base64_to_hex(cipher)
        algorithms << :websphere
      when /hex/i
        cipher = cipher.gsub /\H/, ''
      end
      puts "[*] Hash: #{cipher}" unless @quiet
    end

    algorithms += Array(
      case cipher
      when /^[a-zA-Z]{2}(([A-F0-9]{2}){16}|([a-f0-9]{2}){16})$/
        # hash = salt + md5(salt+password)
        :serv_u
      when /(^([a-f0-9]{2})+$)|(^([A-F0-9]{2})+$)/
        types = case cipher.size
                when 16
                  [:md5_16, :mysql3]
                when 20
                  :dedecms
                when 32
                  [:md2, :md4, :md5, :mdc2, :lm, :ntlm, :ripemd128, :richmail]
                when 40
                  [:sha1, :mysql, :ripemd160]
                when 56
                  :sha224
                when 64
                  [:sha256, :ripemd256, :richmail]
                when 80
                  :ripemd320
                when 96
                  :sha384
                when 128
                  [:sha512, :whirlpool]
                end
        if cipher.size % 32 == 0
          types = Array(types) + [:uportal2800, :navicat12, :interlib]
        end
        types = Array(types) + [:foxmail, :foxmail6]
        if cipher.size > 2 and cipher[0,2].to_i(16) <= 50
          types = Array(types) << :cisco_type7
        end
        if cipher.size > 2
          types = Array(types) + [:flashfxp, :navicat11]
        end
        if cipher.size > 80
          types = Array(types) << :cisco_vpn
        end
        if cipher.size >= 16
          types = Array(types) + [:securecrt, :d3des_vnc]
        end
        if cipher.size >= 96
          types = Array(types) << :securecrt_v2
        end
        if cipher.size == 32 and cipher.end_with?('FF1C39567390ADCA')
          types = Array(types) << :mac_osx_vnc
        end
        types
      when /^\$9\$/
        :juniper_type9
      when /^\p{ASCII}{24}$/, /^\p{ASCII}{88}$/
        :h3c_huawei
      when /^[A-Za-z0-9_+\/=-]{10,}\.([A-Za-z0-9_+\/=-]{3,})\.[A-Za-z0-9_+\/=-]{3,}$/
        :signer
      when /(^([a-f0-9]{2})+!$)|(^([A-F0-9]{2})+!$)/
        :foxmail
      when /(^(0x|\*)([a-f0-9]{2})+$)|(^(0x|\*)([A-F0-9]{2})+$)/
        case cipher.size
        when 94, 54, 142
          :mssql
        when 41
          :mysql
        else
          :unkown
        end
      else
        :unkown
      end
    )
    if cipher.bytesize % 16 == 0
      algorithms << :seeyon_nc
    end
    if cipher.match?(/^(0\d{2}|11\d|12[0-7])+$/)
      algorithms << :filezilla
    end
    if cipher.match?(/^(\h{2})+:\d+:\h{40}:[^:]+$/)
      algorithms << :qizhi_php
    end 
    if cipher.start_with? '02:'
      algorithms += [:securecrt_v2]
      cipher = cipher[3..-1]
    elsif cipher[0] == 'u' and cipher.size.odd?
      algorithms += [:securecrt]
      cipher = cipher[1..-1]
    elsif cipher =~ /^-?((?:\d{0,3}-)+\d{0,3})$/
      algorithms += [:h3c_imc]
      cipher = $1
    elsif cipher =~ /^___((00\h\h)+)/
      algorithms += [:finereport]
      cipher = $1
    elsif cipher =~ /^\/(1\.0|2\.4)\/(\w+=*)/
      algorithms += [:seeyon_a8]
      cipher = $2.unpack1('m0').unpack1('H*')
    end
    if cipher.match? /^((00\h\h)+)$/
      algorithms += [:finereport]
    end
    if cipher.size < 20 and cipher.upcase != cipher and cipher.downcase != cipher
      algorithms += [:zfsoft]
    end
    if cipher =~ /^Encrypted(\w+.{,2})/
      algorithms = [:trswcm]
      cipher = $1.tr('.', '=')
    end
    if cipher.each_char.filter{ '0d5e9n1348/U2+67'.include? _1 }.size.even?
      algorithms += [:mobaxterm]
    end
    if cipher.match? /^\h+$/
      algorithms += [:seeyon_analyze_icloud]
    end
    algorithms.delete(:unkown) if algorithms.include?(:unkown) and algorithms.size > 1
    passwd.algos = algorithms.uniq
    passwd.cipher = cipher
  end
end
