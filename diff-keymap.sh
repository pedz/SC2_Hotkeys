#!/bin/bash

if [[ $# != 2 ]] ; then
  echo "Usage: $( basename $0 ) map1 map2" 1>&2
  exit 1
fi
for map in "$1" "$2" ; do
  cat "$map" | tr -d '\r' | sed -e 's%Option%Alt%g' | sort -u -o "/tmp/$map"
done
diff "/tmp/$1" "/tmp/$2"
