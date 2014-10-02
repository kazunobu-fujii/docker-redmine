#!/bin/sh

set -eux

bundle exec rake generate_secret_token
RAILS_ENV=production bundle exec rake db:migrate
bundle exec unicorn -E production -c config/unicorn.rb

