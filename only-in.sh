#!/bin/bash

for i in $( cat List ) ; do
  echo in-$i.txt
done > /tmp/in-list
for i in $( cat /tmp/in-list ) ; do
  sort -u $( grep -v $i /tmp/in-list ) -o /tmp/TEMP
  comm -23 $i /tmp/TEMP > only-$i
done
