# 0x00 pwcrack-framework
pwcrack-framework 是一个用Ruby编写的密码自动破解框架，目前提供了26个在线破解和8个离线破解接口，支持24种算法破解

项目地址：[https://github.com/L-codes/pwcrack-framework](https://github.com/L-codes/pwcrack-framework)

# 0x01 Features
- Ruby2.5+ (tested with Ruby2.5.3 & Ruby 2.6.3)
- 支持Linux/OSX/Windows平台运行
- 支持在线和离线的进行破解密码明文
- 支持自动分析密文算法调用插件破解
- 提供简单DSL编写框架插件
- 选择性提高性能，可以安装`gem install typhoeus` (windows需要装libcurl可以忽略)

# 0x02 Installing
```
$ git clone https://github.com/L-codes/pwcrack-framework
$ gem install faraday_middleware faraday-cookie_jar rainbow ruby-progressbar msgpack
```
#### banner view
![banner](https://i.imgur.com/vwhJD12.png)

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
在v1.4.0之后版本，添加了本地的密码数据库(大多数为cmd5等需收费查询)
localdb 插件，会查询本地的数据库

初次使用或更新需要重新创建数据库，则执行如下命令
$ pwcrack updatedb

也可以自定义字典进行创建数据库
$ pwcrack updatedb my_dict.txt
```
![localdb](https://i.imgur.com/NGUou5D.png)

# 0x06 Problem
遇到收费的password也可以提交[Issues](https://github.com/L-codes/pwcrack-framework/issues)，共同完善localdb
如在使用过程中发现bug或有好的建议，欢迎提交[Issues](https://github.com/L-codes/pwcrack-framework/issues)和[Pull Requests](https://github.com/L-codes/pwcrack-framework/pulls)
