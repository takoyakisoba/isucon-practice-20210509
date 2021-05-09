.PHONY: gogo

gogo: services/stop build truncate-logs services/start bench

build:
	cd go/ && make isucari

services/stop:
	sudo systemctl stop isucari.golang
	sudo systemctl stop nginx
	sudo systemctl stop mysql

services/start:
	sudo systemctl start mysql
	sudo systemctl start nginx
	sudo systemctl start isucari.golang

truncate-logs:
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	sudo truncate --size 0 /var/log/mysql/error.log

bench:
	ssh -l ubuntu -i .ssh/id_rsa 13.231.82.53 cd /home/isucon/isucari \&\& /home/isucon/isucari/bin/benchmarker -target-url http://18.183.105.62:80 -shipment-url http://13.231.82.53:7000 -payment-url http://13.231.82.53:5555

kataribe:
	sudo cp /var/log/nginx/access.log /tmp/last-access.log && sudo chmod 666 /tmp/last-access.log
	cd ../ && cat /tmp/last-access.log | ./kataribe -conf kataribe.toml > /tmp/kataribe.log
	cat /tmp/kataribe.log
