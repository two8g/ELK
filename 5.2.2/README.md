# ELK运维笔记

*版本:5.2.2*

## Elasticsearch

后台运行

```shell
bin/elasticsearch -d
```

## Logstash

add file `config/first-pipeline.conf`

```
input {
  log4j {
    host => "127.0.0.1"
    port => 8080
  }
}
output {
    elasticsearch {
        hosts => [ "127.0.0.1:9200" ]
    }
}
```

启动

```shell
bin/logstash -f config/first-pipeline.conf
```


错误

```shell
LoadError: load error: jopenssl/load -- java.lang.NoClassDefFoundError: org/bouncycastle/crypto/params/AsymmetricKeyParameter
  require at org/jruby/RubyKernel.java:1040
   (root) at /home/two8g/Develop/IdeaProjects/ELK/5.2.2/logstash-5.2.2/vendor/jruby/lib/ruby/shared/openssl.rb:1
  require at org/jruby/RubyKernel.java:1040
   (root) at /home/two8g/Develop/IdeaProjects/ELK/5.2.2/logstash-5.2.2/logstash-core/lib/logstash/patches/stronger_openssl_defaults.rb:1
  require at org/jruby/RubyKernel.java:1040
   (root) at /home/two8g/Develop/IdeaProjects/ELK/5.2.2/logstash-5.2.2/logstash-core/lib/logstash/patches/stronger_openssl_defaults.rb:2
  require at org/jruby/RubyKernel.java:1040
   (root) at /home/two8g/Develop/IdeaProjects/ELK/5.2.2/logstash-5.2.2/logstash-core/lib/logstash/patches.rb:1
  require at org/jruby/RubyKernel.java:1040
   (root) at /home/two8g/Develop/IdeaProjects/ELK/5.2.2/logstash-5.2.2/logstash-core/lib/logstash/patches.rb:5
  require at org/jruby/RubyKernel.java:1040
   (root) at /home/two8g/Develop/IdeaProjects/ELK/5.2.2/logstash-5.2.2/lib/bootstrap/environment.rb:70
```

解决办法:修改文件 logstash-5.2.2/vendor/jruby/lib/ruby/shared/jopenssl/load.rb

```ruby
# NOTE: assuming user does pull in BC .jars from somewhere else on the CP
unless ENV_JAVA['jruby.openssl.load.jars'].eql?('false')
  version = Jopenssl::Version::BOUNCY_CASTLE_VERSION
  bc_jars = nil
  begin
    require 'jar-dependencies'
    # if we have jar-dependencies we let it track the jars
    # require_jar( 'org.bouncycastle', 'bcpkix-jdk15on', version )
    # require_jar( 'org.bouncycastle', 'bcprov-jdk15on', version )
    bc_jars = false
  rescue LoadError
  end
  unless bc_jars
    load "org/bouncycastle/bcpkix-jdk15on/#{version}/bcpkix-jdk15on-#{version}.jar"
    load "org/bouncycastle/bcprov-jdk15on/#{version}/bcprov-jdk15on-#{version}.jar"
  end
end
```
## Kibana

### 参考

1. [elastic](https://www.elastic.co/)
2. [elastic 5.1.x](https://my.oschina.net/OutOfMemory/blog/826689)
3. [grokdebug](http://grokdebug.herokuapp.com/) 
