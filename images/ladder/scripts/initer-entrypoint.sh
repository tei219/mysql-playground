#!/bin/bash
set -f
if [ ! -e /done ]; then
    for i in $(find /initer.d -type f | sort -n);
    do
        bash $i
    done
fi
echo done > /done