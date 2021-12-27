#!/bin/bash
eval "$(command cat vars.sh)"
cmd="docker run -it localhost/$DISTRO-builder:latest bash"

eval "$cmd"
