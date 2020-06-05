# Docker image for running shell commands only once for initialisation
This image is meant for running shell commands in docker containers only once. Ideally used for any kind of initialisation.

## Usage: directly via docker
```
docker run kamalook/docker-init "echo hello" "echo world"
```

## Usage: via docker-compose
```
version: "3"

services:
  init:
    image: kamalook/docker-init
    command:
      - echo hello
	  - echo world
```
