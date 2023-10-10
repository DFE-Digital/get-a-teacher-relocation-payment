#!/usr/bin/env sh
#
# Dockerfile application startup script
#

set -e

# run migrations
bundle exec rails db:migrate
# Front load urn generation
bundle exec rake urn:generate

# add seed data in review environment
if [[ "$RAILS_ENV" = "review" || "$RAILS_ENV" = "development" ]]; then
    echo "Running rails db:seed"
    bundle exec rails db:seed
fi

# start server
bundle exec rails server -b 0.0.0.0
