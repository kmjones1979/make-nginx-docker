# Makefile for building and managing nginx docker images
# Author; Kevin Jones <kevin@kevinjonescreates.com>

# See the make help command for a list of available features

ngx_version = 1.25.4
os_version = centos8
http_port = 80
https_port = 443
ngx_diff = 1.25.3


default: wget conf dockerfile build

clean: stop rm rmi

wget:
		if [ ! -d tmp/nginx/src/nginx-$(ngx_version) ]; then \
			mkdir -p tmp/nginx/src && \
			wget http://nginx.org/download/nginx-$(ngx_version).tar.gz -O tmp/nginx/src/nginx-$(ngx_version).tar.gz -P tmp/nginx/src && \
			tar -xvzf tmp/nginx/src/nginx-$(ngx_version).tar.gz -C tmp/nginx/src && \
			rm -rf tmp/nginx/src/nginx-$(ngx_version).tar.gz; \
		else \
			echo "Source code already exists"; \
		fi

conf:
		if [ ! -d tmp/nginx/src/nginx-$(ngx_version) ]; then \
			echo "Please run 'make wget' first"; \
		else \
			if [ ! -d etc/nginx/nginx.conf ]; then \
				mkdir -p etc/nginx && \
				cp -r tmp/nginx/src/nginx-$(ngx_version)/conf/* etc/nginx && \
				cp -r tmp/nginx/src/nginx-$(ngx_version)/html etc/nginx && \
				echo "Configuration copied"; \
			else \
				echo "Configuration already exists"; \
			fi; \
		fi

dockerfile:
		if [ -f Dockerfile ]; then \
			echo "Dockerfile already exists"; \
		else \
			if [ ! -f ./docker/$(os_version)/Dockerfile ]; then \
				echo "Dockerfile not found in source location"; \
			else \
				cp ./docker/$(os_version)/Dockerfile Dockerfile && \
				echo "Dockerfile copied from ./docker/$(os_version)/Dockerfile to ./"; \
			fi; \
		fi

build:
		if [ ! -d tmp/nginx/src/nginx-$(ngx_version) ]; then \
			echo "Please run 'make wget' first"; \
		else \
			docker build --no-cache -t nginx-$(ngx_version) . && \
			docker images | grep nginx; \
		fi

stop:
		if [ "$(shell docker ps -a -q --filter name=nginx-$(ngx_version) --format="{{.ID}}")" != "" ]; then \
			docker stop $(shell docker ps -a -q --filter name=nginx-$(ngx_version) --format="{{.ID}}"); \
		else \
			echo "No running container"; \
		fi

start:
		if [ "$(shell docker ps -a -q --filter name=nginx-$(ngx_version) --format="{{.ID}}")" != "" ]; then \
			docker start $(shell docker ps -a -q --filter name=nginx-$(ngx_version) --format="{{.ID}}"); \
		else \
			echo "No container to start"; \
		fim

rm:
		if [ "$(shell docker ps -a -q --filter name=nginx-$(ngx_version) --format="{{.ID}}")" != "" ]; then \
			docker rm -f $(shell docker ps -a -q --filter name=nginx-$(ngx_version) --format="{{.ID}}"); \
		else \
			echo "No container to remove"; \
		fi

rmi:
		if [ "$(shell docker images -q --filter reference=nginx-$(ngx_version) --format="{{.ID}}")" != "" ]; then \
			docker rmi -f $(shell docker images -q --filter reference=nginx-$(ngx_version) --format="{{.ID}}"); \
		else \
			echo "No image to remove"; \
		fi

run:
		if [ "$(shell docker images -q --filter reference=nginx-$(ngx_version) --format="{{.ID}}")" != "" ]; then \
			if [ "$(shell docker ps -a -q --filter ancestor=nginx-$(ngx_version) --format="{{.ID}}")" != "" ]; then \
				echo "Container already exists"; \
			else \
				docker run -d --name nginx-$(ngx_version) -p $(http_port):80 -p $(https_port):443 nginx-$(ngx_version) && \
					docker ps | grep nginx; \
			fi \
		else \
			echo "Please run 'make build' first"; \
		fi 

attach:
		if [ "$(shell docker ps -a -q --filter ancestor=nginx-$(ngx_version) --format="{{.ID}}")" != "" ]; then \
			docker exec -it nginx-$(ngx_version) /bin/bash; \
		else \
			echo "No container to attach"; \
		fi

logs:
		if [ "$(shell docker ps -a -q --filter ancestor=nginx-$(ngx_version) --format="{{.ID}}")" != "" ]; then \
			docker logs nginx-$(ngx_version); \
		else \
			echo "No container to show logs"; \
		fi

nginx-logs:
		if [ "$(shell docker ps -a -q --filter ancestor=nginx-$(ngx_version) --format="{{.ID}}")" != "" ]; then \
			docker exec -it nginx-$(ngx_version) tail -f /var/log/nginx/access.log /var/log/nginx/error.log; \
		else \
			echo "No container to show logs"; \
		fi

diff:
		if [ ! -d tmp/nginx/src/nginx-$(ngx_diff) ]; then \
			mkdir -p tmp/nginx/src && \
			wget http://nginx.org/download/nginx-$(ngx_diff).tar.gz -O tmp/nginx/src/nginx-$(ngx_diff).tar.gz -P tmp/nginx/src && \
			tar -xvzf tmp/nginx/src/nginx-$(ngx_diff).tar.gz -C tmp/nginx/src; \
		fi && \
		diff -bur tmp/nginx/src/nginx-$(ngx_diff) tmp/nginx/src/nginx-$(ngx_version) | tee -a diff-$(ngx_diff)-$(ngx_version).patch && \
			rm -rf tmp/nginx/src/nginx-$(ngx_diff) && \
			rm -f tmp/nginx/src/nginx-$(ngx_diff).tar.gz
wipe:
		rm -rf tmp/nginx/src/nginx-$(ngx_version) && \
		rm -rf etc/nginx && \
		rm -f Dockerfilem

help:
		echo "Usage: make [target]" && \
		echo "" && \
		echo "\"make\" runs wget, conf, dockerfile, build by default" && \
		echo "" && \
		echo "Targets:" && \
		echo "  wget:     			download nginx source" && \
		echo "  conf:     			copy nginx configuration from source" && \
		echo "  dockerfile:			load dockerfile from docker dir based on os" && \
		echo "  build:    			build docker image" && \
		echo "  run:      			run docker container" && \
		echo "  attach:   			attach to docker container" && \
		echo "" && \
		echo "  clean:    			runs stop, rm, rmi" && \
		echo "  stop:     			stop docker container" && \
		echo "  start:    			start the nginx container" && \
		echo "  rm:       			remove docker container" && \
		echo "  rmi:      			remove docker image" && \
		echo "  logs:     			show docker container logs" && \
		echo "  nginx-logs:			show nginx logs" && \
		echo "  diff:     			diff nginx versions" && \
		echo "  wipe:     			wipe out all downloaded files" && \
		echo "  help:     			show this help message"
		echo "" && \
		echo "Makefile variable definitions:"
		echo "  ngx_version			version of nginx to use e.g. 1.25.4"
		echo "  ngx_diff			version of nginx to diff e.g. 1.25.3"
		echo "  os_version			operating system of docker image e.g. centos8"
		echo "  http_port			exposed container port for http e.g. 80"
		echo "  https_port			exposed container port of https e.g. 443"

.SILENT: start wget conf dockerfile build clean stop rm rmi run attach logs nginx-logs diff wipe help

.PHONY: dockerfile