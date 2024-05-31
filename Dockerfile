FROM ruby:3.2.3-alpine3.19

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apk add --update --no-cache tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

# Install build dependencies
RUN apk add --update --no-cache --virtual .build-deps \
    postgresql-dev build-base \
    && apk add --update --no-cache libpq yarn yaml-dev

# Copy Gemfile and Gemfile.lock before bundle install
COPY .tool-versions Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --without=test development --jobs=4

# Clean up bundler cache
RUN rm -rf /usr/local/bundle/cache

# Remove build dependencies
RUN apk del .build-deps

# Copy package.json and yarn.lock and install yarn packages
COPY package.json yarn.lock ./
RUN  yarn install --frozen-lockfile && \
    yarn cache clean

COPY . .

RUN echo export PATH=/usr/local/bin:\$PATH > /root/.ashrc
ENV ENV="/root/.ashrc"

ARG COMMIT_SHA
ENV COMMIT_SHA=$COMMIT_SHA

ARG GOVUK_NOTIFY_API_KEY
ENV GOVUK_NOTIFY_API_KEY=$GOVUK_NOTIFY_API_KEY

ARG GOVUK_NOTIFY_GENERIC_EMAIL_TEMPLATE_ID
ENV GOVUK_NOTIFY_GENERIC_EMAIL_TEMPLATE_ID=$GOVUK_NOTIFY_GENERIC_EMAIL_TEMPLATE_ID

# Precompile assets and clean up
RUN RAILS_ENV=production \
    SECRET_KEY_BASE=required_but_does_not_matter_for_assets \
    bundle exec rake assets:precompile && \
    rm -rf node_modules tmp && \
    apk del yarn nodejs

# Set the default command
CMD ./bin/app-startup.sh
