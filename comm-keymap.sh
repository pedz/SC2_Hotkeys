#!/bin/bash

if [[ "$1" = -[123] || "$1" = -[123][123] ]] ; then
  arg="$1"
  shift
fi
if [[ $# != 2 ]] ; then
  echo "Usage: $( basename $0 ) map1 map2" 1>&2
  exit 1
fi
for map in "$1" "$2" ; do
  cat "$map" | tr -d '\r' | sed -e 's%Option%Alt%g' | sort -u -o "/tmp/$map"
done
comm $arg "/tmp/$1" "/tmp/$2"
