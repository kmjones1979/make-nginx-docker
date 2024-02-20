# A Proxy experiment

This tool helps build nginx foss from source and orchestrate nginx in docker.

## Requirements

-   make (3.81+)
-   docker

## Dockerfiles currently available

-   CentOS 7
-   CentOS 8

## Variable definitions

-   ngx_version - The version of nginx you want to build from source
-   ngx_diff - The previous version so that you can get a diff report
-   dockerfile - The location of the Dockerfile you want to use in the docker folder

## Commands available

To get a list of all available make commands type `make help`

```
$_ make help
Usage: make [target]

"make" runs wget, conf, dockerfile, build by default

Targets:
  wget:                         download nginx source
  conf:                         copy nginx configuration from source
  dockerfile:                   load dockerfile from docker dir based on os
  build:                        build docker image
  run:                          run docker container
  attach:                       attach to docker container

  clean:                        runs stop, rm, rmi
  stop:                         stop docker container
  start:                        start the nginx container
  rm:                           remove docker container
  rmi:                          remove docker image
  logs:                         show docker container logs
  nginx-logs:                   show nginx logs
  diff:                         diff nginx versions
  wipe:                         wipe out all downloaded files
  help:                         show this help message

Makefile variable definitions:
  ngx_version                   version of nginx to use e.g. 1.25.4
  ngx_diff                      version of nginx to diff e.g. 1.25.3
  os_version                    operating system of docker image e.g. centos8
  http_port                     exposed container port for http e.g. 80
  https_port                    exposed container port of https e.g. 443
```
