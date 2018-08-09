#!/bin/bash

IFS=$'\n'

for f in $(find . -maxdepth 1 -type f); do
    ext=$(echo $f | perl -ne '/\.([^.]+)$/ && print $1')
    sha1=$(sha1sum $f | perl -ae 'print $F[0]')
    mv -v "$f" "${sha1}.${ext}"
done
