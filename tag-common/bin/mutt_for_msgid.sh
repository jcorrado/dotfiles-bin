#!/bin/bash

set -e

WINDOW_POSITION="124x33+1054+107"

msgid="$1"
if test -z $msgid; then
    echo please supply a Message-ID
    exit 1
fi

maildir=$(mktemp -d)

mu find -ru --format=links --clearlinks --linksdir=$maildir "i:$msgid"
xfce4-terminal --geometry=$WINDOW_POSITION --command="zsh -ic \"mutt -e 'set quit=yes' -f $maildir\""
