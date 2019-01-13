#!/usr/bin/perl

# Create an org-mode task (default), a reply task, or enqueue a link.

use warnings;
use strict;

use Email::Simple;
use Getopt::Std;

# Optionally map a category to a capture template, to define the
# refile target
my %CATEGORIES = ( personal => { task  => 'mp', reply => 'rp'},
                   birchbox => { task  => 'mb', reply => 'rb'}
    );

our ($opt_c, $opt_l, $opt_r);
getopts ('c:lr');

my $cat = $opt_c || 'personal';
my $type;
if ($opt_l) {
    $type = 'link';
} elsif ($opt_r) {
    $type = 'reply'
} else {
    $type = 'task'
}

my $org_template = $CATEGORIES{$cat}{$type};

my $msg;
{
    local $/;
    $msg = <STDIN>
}
exit if $msg =~ /^\n?$/;

my $email = Email::Simple->new($msg);

my $message_id = clean_message_id($email->header('Message-Id'));
my $subject = clean_str_for_org_link($email->header('Subject'));
my $from = clean_str_for_org_link($email->header('From'));

my $org_protocol_uri;

if ($type eq 'link') {
    $org_protocol_uri = sprintf(
        'org-protocol://store-link?url=message-id:%s&title=%s-%s',
        $message_id,
        $from,
        $subject);
} else {
    $org_protocol_uri = sprintf(
        'org-protocol://capture?template=%s&url=message-id:%s&title=%s-%s',
        $org_template,
        $message_id,
        $from,
        $subject);
}

unless (system("emacsclient '$org_protocol_uri'") == 0) {
    die "fork for emacsclient failed: $!\n";
}

exit 0;

sub clean_message_id {
    my $msg_id = shift;
    $msg_id =~ s/^<//;
    $msg_id =~ s/>$//;
    $msg_id;
}

sub clean_str_for_org_link {
    my $str = shift;
    $str =~ s!['"\[\]]! !g;
    $str;
}
