#!/bin/bash
set -eou pipefail
eval "$(command cat vars.sh)"

BD=$(pwd)/binaries/$DISTRO
[[ -d BD ]] || mkdir -p $BD

NOW=$(date +%s)
CN=$DISTRO-$NOW
IMG=$DISTRO-builder
cmd="docker create $IMG"
>&2 ansi --yellow --italic "$cmd"
CID="$(eval "$cmd")"

docker_cp(){
  local cmd="docker cp $CID:$1 $2"
  >&2 ansi --yellow --italic "$cmd"
  eval "$cmd"
}

cleanup(){
  ansi --yellow --italic "[Cleanup] CID=$CID"
  docker rm $CID
}
trap cleanup EXIT


docker_cp /static/ansible-playbook $BD/ansible-playbook



