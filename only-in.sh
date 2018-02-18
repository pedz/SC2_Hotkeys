#!/bin/bash

# Note that the creation of the negative-* files does not just remove
# the lines that are reset back to their defaults but in at least one
# case, it also deletes the alternatate binding for many keys.

trap 'rm -f $temps' 0
temps=defaults.txt
cat defaults.SC2Hotkeys | tr -d '\r' | sed -e 's%=.*%%' | sort -u -o defaults.txt

for i in $( cat List ) ; do
  temps="$temps negative-$i.txt"
  cat negative-$i.SC2Hotkeys | tr -d '\r' | sed -e 's%=.*%%' | sort -u -o negative-$i.txt
  comm-keymap.sh -3 defaults.txt negative-$i.txt | sort -u -o in-$i.txt
done

temps="$temps in-list"
for i in $( cat List ) ; do
  echo in-$i.txt
done > in-list

for i in $( cat in-list ) ; do
  list=$( grep -v $i in-list )
  temps="$temps all-but-$i"
  (
    sort -u $list -o all-but-$i
    comm -23 $i all-but-$i > only-$i
  )
done
sort -u $( grep in-Campaign in-list ) -o in-Campaign.txt
sort -u $( grep in-Verses in-list ) -o in-Verses.txt
comm -13 in-Campaign.txt in-Verses.txt > only-in-Verses.txt
comm -23 in-Campaign.txt in-Verses.txt > only-in-Campaign.txt
cnt=$( wc -l < in-list )
sort $( cat in-list ) | uniq -c | awk "\$1 == $cnt { print \$2; }" > in-all.txt
cnt=$( grep -v Global in-list | wc -l )
sort $( cat in-list ) | uniq -c | awk "\$1 == $cnt { print \$2; }" > in-all-units.txt
