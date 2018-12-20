#!/usr/bin/perl

use warnings;
use strict;

use Email::Simple;
use Getopt::Std;

our ($opt_f, $opt_t);
getopts ('f:t:');

die "Please supply a file, and optionally a tags string\n" unless $opt_f ;

my $org_task_file = $opt_f;
my $org_tags = $opt_t;

my $msg;
{
    local $/;
    $msg = <STDIN>
}
exit if $msg =~ /^\n?$/;

open my $fh, ">> $org_task_file"
    or die "couldn't open $org_task_file for append: $!\n";
my $email = Email::Simple->new($msg);

my $message_id = clean_message_id($email->header('Message-Id'));
my $subject = clean_str_for_org_link($email->header('Subject'));
my $from = clean_str_for_org_link($email->header('From'));

my $new_task = sprintf
    "* NEXT Followup: [[message-id:%s][%s - %s]]  %s\n" .
    " :PROPERTIES:\n" .
    " :Created: [%s]\n" .
    " :END:\n" .
    "Message Date: %s\n\n",
    $message_id, $from, $subject, $org_tags,
    curr_org_ts(),
    $email->header('Date');

print $fh $new_task;
close $fh;

print "task added to $org_task_file\n\n$new_task";

exit 0;

# Return current ts in org format: 2014-05-12 Mon 08:51
sub curr_org_ts {
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
    $year += 1900;
    my @wdays = qw(Sun Mon Tue Wed Thu Fri Sat);
    return sprintf '%d-%02d-%02d %s %02d:%02d', $year, $mon, $mday, $wdays[$wday], $hour, $min;
}

sub clean_message_id {
    my $msg_id = shift;
    $msg_id =~ s/^<//;
    $msg_id =~ s/>$//;
    $msg_id;
}

sub clean_str_for_org_link {
    my $str = shift;
    $str =~ s![\[\]]! !g;
    $str;
}
