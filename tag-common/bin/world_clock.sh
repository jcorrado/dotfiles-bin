#!/bin/bash

#DATE_FMT='+%Y-%m-%d %H:%M %:z %Z'
DATE_FMT='+%a, %b %d, %Y %H:%M %:z %Z'

echo -n "NYC "; TZ=America/New_York date "$DATE_FMT"
echo -n "UTC "; TZ=UTC date "$DATE_FMT"
echo -e
echo -n "LAX "; TZ=America/Los_Angeles date "$DATE_FMT"
echo -n "NYC "; TZ=America/New_York date "$DATE_FMT"
echo -n "LDN "; TZ=Europe/London date "$DATE_FMT"
echo -n "PAR "; TZ=Europe/Paris date "$DATE_FMT"
echo -n "BCN "; TZ=Europe/Madrid date "$DATE_FMT"
