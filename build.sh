#!/bin/bash
eval "$(command cat vars.sh)"
cmd="docker build -f Dockerfiles/$DISTRO.Dockerfile -t $DISTRO-builder --target $DISTRO-builder ."
>&2 ansi --yellow --italic "$cmd"
eval "$cmd"
