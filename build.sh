#!/bin/bash
eval "$(command cat vars.sh)"

bt(){
  cmd="docker build -f Dockerfiles/$DF -t $TARGET --target $TARGET ."
  >&2 ansi --yellow --italic "$cmd"
  eval "$cmd"
}


DF=fedora32.Dockerfile TARGET=$DISTRO-ansible-playbook bt
#TARGET=$DISTRO-podman-compose bt
