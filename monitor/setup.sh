#!/bin/bash

cd /home/bazhenov/
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.46.0/prometheus-2.46.0.linux-amd64.tar.gz
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

tar xzvf node_exporter-*.t*gz
tar xzvf prometheus-*.t*gz

