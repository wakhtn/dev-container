dev-container
====

## Description
This is a Docker image for develop application. Container includes following runtimes. This is Useful for Visual Studio Code Remote Development for Container.
- GO
- Node
- Python
- Jave 
- Docker

and, includes following tools
- aws-cli
- gcloud
- kubectl (and useful tools, kubens, kubectx, stern)
- terraform
- pulumi

## Requirement
For Execute Docker in container, You must run this container as privileged flag. 

## Usage

### docker run
```
$ docker run --name dev -d --privileged wakhtn/dev-container -v ./work:/root/work
$ docker exec -it dev /bin/bash
```

### docker-compose
```
$ git clone https://github.com/wakhtn/develop-container.git
$ cd develop-contaienr
$ docker-compose up -d
$ docker exec -it dev /bin/bash
```
