# Build, Configure and Run nginx in Docker via make

This tool helps build nginx foss from source and orchestrate nginx in docker.

## Requirements

-   make (3.81+), wget, tar, tee
-   docker

> Note... this was only tested on MacOS - it should work fine on Linux but probably not Windows. :P

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

### Source code download

In each Dockerfile you have the option to download the source code in different ways. You can choose the option best for your needs.

#### 1. Download nginx inside the container

```
RUN wget http://nginx.org/download/nginx-$nginxVersion.tar.gz -P $tmp
RUN tar -zxvf $tmp/nginx-$nginxVersion.tar.gz -C $tmp
```

#### 2. Download the package locally and upload to the container

```
COPY tmp/nginx/src/nginx-$nginxVersion.tar.gz $tmp
RUN tar -zxvf $tmp/nginx-$nginxVersion.tar.gz -C $tmp
```

#### 3. Copy the source code to the container (default)

```
ADD tmp/nginx/src/nginx-$nginxVersion $tmp/nginx-$nginxVersion
```

## Quick Start

Run `make` to download nignx and configure from source using the prebuilt Dockerfile.

```
make
```

# Advanced Configuration

1. Define the version of nginx and os you want to build within the `Makefile` as well as ports you want to expose.

> make sure this matches the `ENV nginxVersion` in the relevant `Dockerfile`

```
ngx_version = 1.25.4
os_version = centos8
http_port = 80
https_port = 443
```

2. Download source, copy config and Dockerfile

Use `make wget`, `make conf` and `make dockerfile` to scaffold out the needed files before building.

3. Generate a diff patch from previous version

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
