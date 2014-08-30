#!/bin/sh

set -eux

if [ -e /redmine-config ]; then
  cp /redmine-config/* ./config/
fi

bundle exec rake generate_secret_token
RAILS_ENV=production bundle exec rake db:migrate
chmod 666 log/*.log

bundle exec unicorn -E production -c config/unicorn.rb

