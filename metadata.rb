name "grack"
maintainer "Clif Smith"
maintainer_email "yo@clif.wtf"
license 'Apache-2.0'
description "Sends Grafana graphs to Slack"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version "0.0.6"

recipe 'grack::cron', 'Manages cron jobs generated from attributes'
recipe 'grack::script', 'Installs the script'

%w(ubuntu debian centos redhat amazon scientific fedora oracle freebsd windows suse opensuse opensuseleap).each do |os|
  supports os
end

chef_version '>= 12' if respond_to?(:chef_version)
source_url 'https://github.com/cjs226/grack' if respond_to?(:source_url)
issues_url 'https://github.com/cjs226/grack/issues' if respond_to?(:issues_url)