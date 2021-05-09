.PHONY: gogo

gogo: services/stop build truncate-logs services/start

build:
	#cd app && make build
	echo "buildしてくれ〜〜"

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

kataribe:
	cd ../ && sudo cat /var/log/nginx/access.log | ./kataribe -conf kataribe.toml

