name        "opsworks_puma"
description "Manage the ruby app server puma on AWS OpsWorks"
maintainer  "Sport Ngin"
license     "MIT"
version     "0.0.5"

depends "nginx"
depends "deploy"
# depends "logrotate"

recipe "opsworks_puma::deploy", "Used during the deploy lifecyle event to ensure nginx is configured properly"
recipe "opsworks_puma", "Setup puma to run for all of a stacks rails applications"
