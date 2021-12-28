#!/bin/bash
eval "$(command cat vars.sh)"
dot(){
  cmd="docker build -f Dockerfiles/test-$DISTRO.Dockerfile -t $TARGET --target $TARGET ."
  >&2 ansi --yellow --italic "$cmd"
  eval "$cmd"
}


TARGET=test-$DISTRO dot

DISTRO=fedora34
TARGET=test-$DISTRO dot

DISTRO=fedora33
TARGET=test-$DISTRO dot

DISTRO=fedora32
TARGET=test-$DISTRO dot

DISTRO=fedora31
TARGET=test-$DISTRO dot
