# 0x00 pwcrack-framework
[简体中文](README.md)　｜　[English](README-en.md)

**pwcrack-framework** 是一个用Ruby编写的密码自动破解框架，目前提供了 25 个在线破解和 18 个离线破解接口，支持 42 种算法破解

项目地址：[https://github.com/L-codes/pwcrack-framework](https://github.com/L-codes/pwcrack-framework)

# 0x01 Features
- Ruby2.6+ (tested with Ruby 2.6.2 & Ruby 2.7.2)
- 支持Linux/OSX/Windows平台运行
- 支持在线和离线的进行破解密码明文
- 支持自动分析密文算法调用插件破解
- 提供简单DSL编写框架插件
- 选择性提高性能，可以安装`gem install typhoeus` (windows需要装libcurl可以忽略)

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
          '$$$$$$$$$$'  $$$$          version 1.11.0
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

         Online Plugin: 25        Offline Plugin: 18
                   supporting algorithms: 42

                  [ Algorithm Plugin Count ] 

         serv_u: 23             md5: 23            sha1: 15
        dedecms: 10          md5_16: 10          sha256:  8
         sha512:  8           mysql:  7            ntlm:  7
         sha384:  5             md4:  5          mysql3:  5
             lm:  4          sha224:  2           mssql:  2
       flashfxp:  1       druid_rsa:  1     cisco_type7:  1
   securecrt_v2:  1       securecrt:  1     mac_osx_vnc:  1
  juniper_type9:  1         foxmail:  1        foxmail6:  1
            md2:  1            mdc2:  1       ripemd128:  1
      ripemd160:  1       ripemd256:  1       ripemd320:  1
      whirlpool:  1          xshell:  1       filezilla:  1
      dahan_jis:  1      dongao_rc4:  1     uportal2800:  1
           xftp:  1       navicat12:  1       navicat11:  1
            gpp:  1       cisco_vpn:  1      h3c_huawei:  1



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
在 v1.4.0 之后版本，添加了本地的密码数据库(大多数为cmd5等需收费查询)
localdb 插件，会查询本地的数据库

初次使用或需要重建本地数据库，则执行如下命令
$ pwcrack initdb

也可以自定义字典进行创建数据库
$ pwcrack initdb my_dict.txt

在 v1.9.8 之后版本，添加了 add 和 updatedb 功能
新增明文到 data/words.txt 则使用
$ pwcrack add <word...>

更新 data/words.txt 中新增的明文记录到数据库则使用
$ pwcrack updatedb
```
![localdb](https://i.imgur.com/Akze0mt.png)

# 0x06 Problem
- 遇到收费的password也可以提交[Issues](https://github.com/L-codes/pwcrack-framework/issues)，共同完善localdb
- 如在使用过程中发现bug或有好的建议，欢迎提交[Issues](https://github.com/L-codes/pwcrack-framework/issues)和[Pull Requests](https://github.com/L-codes/pwcrack-framework/pulls)

