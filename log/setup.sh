#!/bin/bash

cd /home/bazhenov

sudo apt install default-jdk -y

sudo dpkg -i elasticsearch-8.17.1-amd64.deb

cat <<EOF | sudo tee /etc/elasticsearch/jvm.options.d/jvm.options
-Xms1g
-Xmx1g
EOF

cat <<EOF | sudo tee /etc/elasticsearch/elasticsearch.yml
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch

xpack.security.enabled: false
xpack.security.enrollment.enabled: true

xpack.security.http.ssl:
  enabled: false
  keystore.path: certs/http.p12

xpack.security.transport.ssl:
  enabled: false
  verification_mode: certificate
  keystore.path: certs/transport.p12
  truststore.path: certs/transport.p12
cluster.initial_master_nodes: ["elk"]

http.host: 0.0.0.0
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now elasticsearch.service

sudo dpkg -i kibana-8.17.1-amd64.deb

sudo systemctl daemon-reload
sudo systemctl enable --now kibana.service

cat <<EOF | sudo tee /etc/kibana/kibana.yml
server.port: 5601
server.host: "0.0.0.0"
logging:
  appenders:
    file:
      type: file
      fileName: /vat/log/kibana/kibana.log
      layout:
        type: json
  root:
    appenders:
      - default
      - file
pid.file: /run/kibana/kibana.pid
EOF

sudo dpkg -i logstash-8.17.1-amd64.deb
sudo systemctl enable --now logstash.service

cat <<EOF | sudo tee /etc/logstash/logstash.yml
path.data: /var/lib/logstash
path.config: /etc/logstash/conf.d
path.logs: /var/log/logstash/
EOF

cat <<EOF | sudo tee /etc/logstash/conf.d/logstash-nginx-es.conf
input {
    beats {
        port => 5400
    }
}

filter {
 grok {
   match => [ "message" , "%{COMBINEDAPACHELOG}+%{GREEDYDATA:extra_fields}"]
   overwrite => [ "message" ]
 }
 mutate {
   convert => ["response", "integer"]
   convert => ["bytes", "integer"]
   convert => ["responsetime", "float"]
 }
 date {
   match => [ "timestamp" , "dd/MMM/YYYY:HH:mm:ss Z" ]
   remove_field => [ "timestamp" ]
 }
 useragent {
   source => "agent"
 }
}

output {
 elasticsearch {
   hosts => ["http://localhost:9200"]
   #cacert => '/etc/logstash/certs/http_ca.crt'
   #ssl => true
   index => "weblogs-%{+YYYY.MM.dd}"
   document_type => "nginx_logs"
 }
 stdout { codec => rubydebug }
}
EOF

sudo systemctl restart logstash.service

sudo dpkg -i filebeat-8.17.1-amd64.deb

cat <<EOF | sudo tee /etc/filebeat/filebeat.yml
filebeat.inputs:
- type: filestream
  paths:
    - /var/log/nginx/*.log

  enabled: true
  exclude_files: ['.gz$']
  prospector.scanner.exclude_files: ['.gz$']

filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: false

output.logstash:
  hosts: ["localhost:5400"]


EOF

