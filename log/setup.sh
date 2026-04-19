#!/bin/bash

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
