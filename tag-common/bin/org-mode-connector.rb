#!/usr/bin/env ruby

require 'mail'
require 'erb'

org_link_uri = "org-protocol://store-link?url=message-id:%s&title=%s"
org_capture_uri = "org-protocol://capture?url=message-id:%s&title=%s&template=%s"

mail = Mail.read_from_string($stdin.read)
template = ARGV.shift

if (template)
  org_protocol_uri = org_capture_uri % [ERB::Util::url_encode(mail.message_id),
                                        ERB::Util::url_encode("#{mail.from.first}: #{mail.subject}"),
                                        template]
else
  org_protocol_uri = org_link_uri % [ERB::Util::url_encode(mail.message_id),
                                     ERB::Util::url_encode("#{mail.from.first}: #{mail.subject}")]
end

system("emacsclient", org_protocol_uri) or
  raise "failed to run emacsclient"
