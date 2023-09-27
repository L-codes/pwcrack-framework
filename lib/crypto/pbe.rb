module Crypto
module PBE

  def self.decrypt(str, password, salt, iter=100, algo='DES', digest='MD5')
    pbe_des = OpenSSL::Cipher.new(algo)
    pbe_des.decrypt
    pbe_des.pkcs5_keyivgen password, salt, iter, digest
    pbe_des.update(str) + ( pbe_des.final rescue '')
  end

end # PBE end
end # Crypto end
