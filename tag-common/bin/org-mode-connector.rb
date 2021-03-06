#!/usr/bin/env ruby

require 'mail'
require 'erb'

org_link_uri = "org-protocol://store-link?url=message-id:%s&title=%s"
org_capture_uri = "org-protocol://capture?url=message-id:%s&title=%s&template=%s"

template = ARGV.shift
mail = Mail.read_from_string($stdin.read)
message_id = ERB::Util::url_encode(mail.message_id)
title =  ERB::Util::url_encode("#{mail.from.first}: #{mail.subject}"[0..55])

if (template)
  org_protocol_uri = org_capture_uri % [message_id, title, template]
else
  org_protocol_uri = org_link_uri % [message_id, title]
end

system("emacsclient", org_protocol_uri) or
  raise "failed to run emacsclient"

# Our "mp" and "mw" templates (see `org-capture-templates') allow for
# populating some details, so we move focus over to Emacs.
if template == "mp" or template == "mw"
  sleep(1.0/3)
  system("wmctrl", "-a", "CAPTURE-refile.org") or
    raise "failed to run wmctrl"
end
