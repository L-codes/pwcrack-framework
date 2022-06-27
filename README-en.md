# 0x00 pwcrack-framework
+ [简体中文](README.md)　｜　[English](README-en.md)

**pwcrack-framework** is a password automatic cracking framework written in Ruby, currently provides 22 online cracks and 30 offline crack interfaces, supporting 53 algorithms to crack.

project address：[https://github.com/L-codes/pwcrack-framework](https://github.com/L-codes/pwcrack-framework)

# 0x01 Features
- Ruby2.7+ (tested with Ruby 2.7.2 & Ruby 3.1.1)
- Support for Linux/OSX/Windows platform operation
- Support online and offline crack password clear text
- Support automatic analysis of ciphertext algorithm call plugin crack
- Provide a simple DSL writing framework plugin
- Configure java environment extension, support more algorithms, install `gem install rjb`

# 0x02 Installing
```
$ git clone https://github.com/L-codes/pwcrack-framework
$ cd pwcrack-framework
$ bundle install

# banner view
$ ./pwcrack banner

                                             
          "$$$$$$''  'M$  '$$$@m            
        :$$$$$$$$$$$$$$''$$$$'               
       '$'    'JZI'$$&  $$$$'                
                 '$$$  '$$$$                 
                 $$$$  J$$$$'                
                m$$$$  $$$$,                
                $$$$@  '$$$$_         pwcrack-framework
             '1t$$$$' '$$$$<               
          '$$$$$$$$$$'  $$$$          version 1.16.11
               '@$$$$'  $$$$'                
                '$$$$  '$$$@                 
             'z$$$$$$  @$$$                  
                r$$$   $$|                   
                '$$v c$$                     
               '$$v $$v$$$$$$$$$#            
               $$x$$$$$$$$$twelve$$$@$'      
             @$$$@L '    '<@$$$$$$$$`        
           $$                 '$$$           
                                             

    [ Github ] https://github.com/L-codes/pwcrack-framework

                       [ Plugin Count ] 

         Online Plugin: 22        Offline Plugin: 30
                   supporting algorithms: 53

                  [ Algorithm Plugin Count ] 

         serv_u: 20             md5: 20            sha1: 12
        dedecms: 10          md5_16: 10           mysql:  8
           ntlm:  7          mysql3:  6          sha256:  6
         sha512:  6              lm:  4             md4:  4
          mssql:  2          sha384:  2     landray_ekp:  1
  juniper_type9:  1         h3c_imc:  1      h3c_huawei:  1
        grafana:  1             gpp:  1         foxmail:  1
       foxmail6:  1        flashfxp:  1      finereport:  1
      filezilla:  1       druid_rsa:  1      dongao_rc4:  1
      whirlpool:  1          sha224:  1       ripemd320:  1
      ripemd256:  1       ripemd160:  1       ripemd128:  1
           mdc2:  1             md2:  1       dahan_jis:  1
      d3des_vnc:  1       cisco_vpn:  1     cisco_type7:  1
         xshell:  1            xftp:  1       websphere:  1
    uportal2800:  1          trswcm:  1       seeyon_a8:  1
   securecrt_v2:  1       securecrt:  1       qizhi_php:  1
      navicat12:  1       navicat11:  1       mobaxterm:  1
    mac_osx_vnc:  1        lsrunase:  1          zfsoft:  1


# Install in Termux
$ pkg install git ruby ruby-dev clang make libffi-dev
$ gem install bundler
$ git clone https://github.com/L-codes/pwcrack-framework
$ cd pwcrack-framework
$ bundle update --bundler
```

# 0x03 Example usage
## Examples 1
![examples1](https://i.imgur.com/o9QpPkK.png)
## Examples 2
![examples2](https://i.imgur.com/X0YYywh.png)
## Examples 3
![examples3](https://i.imgur.com/WHC9aVF.png)
## Examples 4
![examples4](https://i.imgur.com/3Ms2kQL.png)

# 0x04 Plugin Development DSL
```ruby
#!/usr/bin/env ruby
#
# Plugin 80p
# Author L
#

plugin '80p' do
  web_server 'http://md5.80p.cn'
  supported_algorithm :md5, :md5_16, :sha1

  crack {
    r = post '/', {'decode': passwd}
    r.body.extract(/<font color="#FF0000">(.*?)<\/font>/)
  }
end
```

# 0x05 Local DB
```ruby
In v1.4.0 and later, a local password database has been added (大多数为cmd5等需收费查询)
localdb plugin, will query the local database

The first time you use or need to rebuild the local database, execute the following command
$ pwcrack initdb

You can also customize the dictionary to create a database.
$ pwcrack initdb my_dict.txt

Added add and updatedb features in v1.9.8 and later
Add plaintext to data/words.txt to use
$ pwcrack add <word...>

Update the new plaintext record in data/words.txt to the database.
$ pwcrack updatedb
```
![localdb](https://i.imgur.com/Akze0mt.png)

# 0x06 Problem
- If you encounter a charged password, you can also submit [Issues](https://github.com/L-codes/pwcrack-framework/issues) to improve localdb.
- If you find bugs or have good suggestions during use, please submit [Issues](https://github.com/L-codes/pwcrack-framework/issues) and [Pull Requests](https://github. Com/L-codes/pwcrack-framework/pulls)

