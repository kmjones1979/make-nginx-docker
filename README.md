# Build, Configure and Run nginx in Docker via make

This tool helps build nginx foss from source and orchestrate nginx in docker.

## Requirements

-   make (3.81+)
-   docker

## Variable definitions

-   ngx_version - version of nginx to use e.g. 1.25.4
-   ngx_diff - version of nginx to diff e.g. 1.25.3
-   os_version - operating system of docker image e.g. centos8
-   http_port - exposed container port for http e.g. 80
-   https_port - exposed container port of https e.g. 443

## Dockerfiles currently available

> Note: the related Dockerfile for your defined os_version should be in the `./docker/` folder. e.g. `./docker/centos8/Dockerfile`

-   CentOS 7 (located in docker/centos7)
-   CentOS 8 (located in docker/centos8)

## Getting started

1. Define the version of nginx and os you want to build within the `Makefile` as well as ports you want to expose and if you want a diff report from a previous version.

```
ngx_version = 1.25.4
os_version = centos8
http_port = 80
https_port = 443
```

2. Run `make` to download nignx and configure from source using the prebuilt Dockerfile

```
make
```

> Optionally use `make wget`, `make conf` and `make dockerfile` to scaffold out the needed files before building.

3. Optionally generate a diff patch

> If you want to get a diff patch on the changes in the current `tmp/nginx/src` directory update the version you want to diff against in the `Makefile` and run `make diff`

```
ngx_diff = 1.25.3
```

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
