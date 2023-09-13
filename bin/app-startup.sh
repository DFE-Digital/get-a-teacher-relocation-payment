#!/usr/bin/env sh
#
# Dockerfile application startup script
#

# run migrations
bundle exec rails db:migrate

# add seed data in review environment
if [ "$RAILS_ENV" = "review" ]; then
    echo "Running rails db:seed"
    bundle exec rails db:seed
fi

# start server
bundle exec rails server -b 0.0.0.0
