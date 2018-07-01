#!/usr/bin/env ruby
# 
# Password Algorithm Analysis Library
# Author L
# Date   2018-06-30
#

module PasswdLib
  Passwd = Struct.new(:cipher, :algos)

  def passwd_analysis(passwd, algorithms)
    passwd.cipher = base64_to_hex(passwd.cipher) if passwd.cipher.match? /(=|==)$/
    passwd.algos = find_hash_type(passwd.cipher)
    abort 'No ciphertext algorithm found' if passwd.algos == [:unkown]

    unless algorithms.empty?
      passwd.algos &= algorithms.map(&:to_sym)
      abort "Password is not a #{algorithms.map(&:upcase).join(' or ')} algorithm" if passwd.algos.empty?
    end
    passwd.cipher = passwd.cipher.delete(?*) if passwd.algos.include? :mysql 
    passwd.cipher = passwd.cipher.downcase if (passwd.algos & [:juniper_type9, :h3c_huawei]).size > 1
  end

  def base64_to_hex(base64code)
    bytes = Base64.decode64 base64code
    bytes.unpack1 'H*'
  end

  def find_hash_type(cipher)
    algorithm =
      case cipher
      when /(^([a-f0-9]{2})+$)|(^([A-F0-9]{2})+$)/
        types = case cipher.size
                when 16
                  [:md5_16, :mysql3]
                when 32
                  [:md5, :md4, :lm, :ntlm]
                when 40
                  [:sha1, :mysql]
                when 56
                  :sha224
                when 64
                  :sha256
                when 96
                  :sha384
                when 128
                  :sha512
                end
        if cipher.size > 2 and cipher[0,2].to_i(16) <= 50
         types = Array(types) << :cisco_type7 
        end
        types
      when /^\*([a-f0-9]{40}|[A-F0-9]{40})$/
        :mysql
      when /^\$9\$/
        :juniper_type9
      when /^\p{ASCII}{24}$/
        :h3c_huawei
      else
        :unkown
      end
    Array(algorithm)
  end
end
