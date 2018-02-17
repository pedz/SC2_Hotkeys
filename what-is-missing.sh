#!/bin/bash

for i in $1 empty.SC2Hotkeys ; do
  sed -e 's%=.*%%' $i | tr -d '\r' | sort -u -o /tmp/$i
done
cd /tmp
diff $1 empty.SC2Hotkeys
