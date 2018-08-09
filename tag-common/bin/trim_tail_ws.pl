#!/usr/bin/perl
while (<>) {
    s/\s+$/\n/;
    print $_;
}
