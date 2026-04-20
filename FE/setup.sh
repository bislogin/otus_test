#!/bin/bash

sudo systemctl start nginx
sudo systemctl start node_exporter

cat <<EOF | sudo tee /etc/nginx/sites-available/default
upstream backend {
	server 172.20.1.20:80;
	server 172.20.1.30:80;
}
server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        include /etc/nginx/default.d/*.conf;

		location / {
			#try_files $uri $uri/ =404;
			proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Real-IP $remote_addr;
		}
		location ~ \.php$ {
			include fastcgi_params;
			root /var/www/html;

			fastcgi_pass unix:/run/php/php7.4-fpm.sock;
			#fastcgi_pass 127.0.0.1:9000;
		}

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
}
EOF

sudo systemctl restart nginx

cd /home/bazhenov

sudo dpkg -i filebeat_8.17.1_amd64-224190-6bb8de.deb

cat <<EOF | sudo tee /etc/filebeat/filebeat.yml
filebeat.inputs:
- type: filestream
  id: test-nginx
  enabled: true
  paths:
    - /var/log/nginx/*.log     

output.logstash:
  hosts: ["172.20.1.60:5400"]

logging.level: debug

EOF  

systemctl restart filebeat
