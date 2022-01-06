#!/bin/bash
eval "$(command cat vars.sh)"

bt(){
  cmd="docker build -f Dockerfiles/$DISTRO-podman-compose.Dockerfile -t $TARGET --target $TARGET ."
  >&2 ansi --yellow --italic "$cmd"
  eval "$cmd"
}


#TARGET=$DISTRO-ansible-playbook bt
TARGET=$DISTRO-podman-compose bt
