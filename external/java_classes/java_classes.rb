
module_loaded = false
begin
  require 'rjb'
  module_loaded = true
rescue LoadError
end

if module_loaded
  Rjb.add_classpath "#{ROOT}/external/java_classes/"
end
