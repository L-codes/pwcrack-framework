
module_loaded = false
begin
  require 'rjb'
  module_loaded = true
rescue LoadError
end

if module_loaded
  Rjb.add_classpath "#{ROOT}/external/java_ext/classes/"
  
  Dir["#{ROOT}/external/java_ext/jar/*.jar"].each do |file|
    Rjb.add_jar file
  end
end

=begin
if Kernel.const_defined? :Rjb
  EKPDESEncrypt = Rjb.import 'com.landray.kmss.util.DESEncrypt'
  [false, true].find { |israndom|
    des = EKPDESEncrypt.new(key, israndom)
    plain = des.decrypt(passwd.hex2ascii) rescue nil
  }
end
=end
