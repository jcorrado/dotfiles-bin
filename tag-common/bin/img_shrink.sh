#!/bin/bash

for img in "$@"; do
    # resize, preserving aspect ratio
    convert -resize '1024x1024>' $img $img.tmp.$$
    mv $img.tmp.$$ $img
done
