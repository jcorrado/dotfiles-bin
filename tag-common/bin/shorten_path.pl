#!/usr/bin/perl

# Compress path, I use this in shell prompts, xterm titles and screen.

use warnings;
use strict;

my $max_length = $ARGV[0] || 60;

my $username = qx{whoami};
chomp $username;
my $priv_identifier =  $username eq 'root' ? '#' : '$';

my $line = <STDIN>;
$line =~ s/$ENV{HOME}/~/;
$line = "$priv_identifier $line";

while ((length($line) > $max_length) && $line =~ m!/[^/]{2,}!) {
    $line =~ s!/([^/])[^/]+!/$1!;
}

print $line;
