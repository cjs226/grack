name             "grack"
maintainer       "Clif Smith"
maintainer_email "yo@clif.wtf"
license          "Apache 2.0"
description      "Sends Grafana graphs to Slack"
version          "0.0.4"

recipe 'grack::cron', 'Manages cron jobs generated from attributes'
recipe 'grack::script', 'Installs the script'

