#!/bin/bash
eval "$(command cat vars.sh)"
TARGET=$DISTRO-ansible-playbook
cmd="docker build -f Dockerfiles/$DISTRO.Dockerfile -t $TARGET --target $TARGET ."
>&2 ansi --yellow --italic "$cmd"
eval "$cmd"
