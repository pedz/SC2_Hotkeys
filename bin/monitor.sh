#!/bin/bash

function list
{
    for i in $1-* ; do 
	wc=$( sed -e '1,/Commands/d' $i | grep = | wc -l )
	printf "%2d %s\n" $wc $i
    done | sort -n
}

if [[ $# -ne 1 ]] ; then
    echo "Usage: $( basename $0 ) <mode>" 1>&2
    exit 1
fi

if tty <&1 > /dev/null ; then
    while : ; do
	echo "$( clear ; list $1 )"
	read f
    done
else
    list $1
fi
