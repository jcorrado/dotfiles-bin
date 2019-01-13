#!/usr/bin/perl

# Create an org-mode task (default) or enqueue a link.

use warnings;
use strict;

use Email::Simple;
use Getopt::Std;

# Map a category to a capture template (to define the refile target)
# and a string of tags
my %CATEGORIES = (
    personal => { template => 'mp', tags =>  '' },
    birchbox => { template => 'mb', tags =>  '' });

our ($opt_c, $opt_l);
getopts ('c:l');

my $cat = $opt_c;
my $do_link = $opt_l;
my $org_template = $CATEGORIES{$cat}{template} || $CATEGORIES{personal}{template};
my $org_tags = $CATEGORIES{$cat}{tags} || $CATEGORIES{personal}{tags};

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
if ($do_link) {
    $org_protocol_uri = sprintf(
        'org-protocol://store-link?url=message-id:%s&title=%s-%s',
        $message_id,
        $from,
        $subject);
} else {
    $org_protocol_uri = sprintf(
        'org-protocol://capture?template=%s&url=message-id:%s&title=%s-%s&body=%s',
        $org_template,
        $message_id,
        $from,
        $subject,
        $org_tags);
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
