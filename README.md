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

Targets:
  default:                      wget, conf, build
  clean:                        stop, rm, rmi
  wget:                         download nginx source
  conf:                         copy nginx configuration from source
  dockerfile:                   load dockerfile from docker dir
  build:                        build docker image
  run:                          run docker container
  stop:                         stop docker container
  start:                        start the nginx container
  attach:                       attach to docker container
  rm:                           remove docker container
  rmi:                          remove docker image
  logs:                         show docker container logs
  nginx-logs:                   show nginx logs
  diff:                         diff nginx versions
  wipe:                         wipe out all downloaded files
  help:                         show this help message
```
