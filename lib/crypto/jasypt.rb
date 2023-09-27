module Crypto
module Jasypt

  def self.decrypt(str, password)
    msg = str.unpack1('m0')
    PBE.decrypt(msg[8..-1], password, msg[0,8], 1000)
  end

end # PBE end
end # Crypto end
