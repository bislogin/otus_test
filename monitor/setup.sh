#!/bin/bash

sudo apt install prometheus -y
sudo systemctl restart systemd-timesyncd

cat <<'EOF' | sudo tee /etc/prometheus/prometheus.yml
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['172.20.1.70:9090']
  
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['172.20.1.70:9100','172.20.1.10:9100','172.20.1.20:9100','172.20.1.30:9100']
EOF

sudo apt-get install -y adduser libfontconfig1 musl
cd /home/bazhenov/
sudo dpkg -i grafana_13.0.1_24542347077_linux_amd64.deb

sudo systemctl stop prometheus
sudo rm -rf /var/lib/prometheus/metrics2/*
sudo systemctl start prometheus

sudo systemctl daemon-reload
sudo systemctl enable --now grafana-server

