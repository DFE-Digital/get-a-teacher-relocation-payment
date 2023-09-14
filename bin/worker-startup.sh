#!/usr/bin/env sh
#
# worker startup script
#

set -e

# start sidekiq
bundle exec sidekiq -C ./config/sidekiq.yml
