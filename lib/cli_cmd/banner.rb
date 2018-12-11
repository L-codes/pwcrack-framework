#!/usr/bin/env ruby
#
# pwcrack banner
# Author L
#

module CLI

  def self.banner
    puts Banner
    plugin_map = PWCrack.plugins_info 

    web_urls = plugin_map.map{|_, (web, _)| web}
    puts "                       [ Plugin Count ] "
    puts
    algo_sum = web_urls.count nil
    web_sum  = web_urls.size - algo_sum
    puts "         Online Plugin: #{web_sum}        Offline Plugin: #{algo_sum}"
    if @@verbose
      puts
      plugin_map.each do |name, (web, _)|
        next if web.nil?
        puts "      %18s    %s" % [name, web]
      end
    end
    puts

    algo_count = plugin_map.map{|_, (_, algos)| algos}
                           .flatten.group_by(&:itself)
                           .transform_values(&:size)
                           .sort_by{|k,v| v}
                           .reverse
    puts "                  [ Algorithm Plugin Count ] "
    puts
    algo_count.map{|item| '%15s: %2d' % item}.each_slice(3) do |line|
      puts line.join ' '
    end
    puts

    exit
  end

  Banner = <<-EOF
                                             

                                             
          "$$$$$$\''  'M$  '$$$@m            
        :$$$$$$$$$$$$$$''$$$$'               
       '$'    'JZI'$$&  $$$$'                
                 '$$$  '$$$$                 
                 $$$$  J$$$$'                
                m$$$$  \$$$$,                
                $$$$@  '$$$$_         #{Project}
             '1t\$$$$' '$$$$<               
          '$$$$$$$$$$'  $$$$          version #{Version}
               '@$$$$'  $$$$'                
                '$$$$  '$$$@                 
             'z$$$$$$  @$$$                  
                r$$$   $$|                   
                '$$v c$$                     
               '$$v $$v$$$$$$$$$#            
               $$x$$$$$$$$$twelve$$$@$'      
             @$$$@L '    '<@$$$$$$$$`        
           $$                 '$$$           
                                             

    [ Github ] https://github.com/L-codes/#{Project}

  EOF

end
