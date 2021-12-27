#!/bin/bash
eval "$(command cat vars.sh)"
cmd="docker run -it $DISTRO-builder:latest bash"
>&2 ansi --yellow --italic "$cmd"
eval "$cmd"
