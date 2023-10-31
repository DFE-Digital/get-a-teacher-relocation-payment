FROM ruby:3.2.2-alpine

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apk add --update --no-cache tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

COPY .tool-versions Gemfile Gemfile.lock ./

RUN apk add --update --no-cache --virtual build-dependances \
    postgresql-dev build-base && \
    apk add --update --no-cache libpq yarn yaml-dev && \
    bundle install --without=test development --jobs=4 && \
    rm -rf /usr/local/bundle/cache && \
    apk del build-dependances

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

RUN RAILS_ENV=production \
    SECRET_KEY_BASE=required_but_does_not_matter_for_assets \
    bundle exec rake assets:precompile && \
    rm -rf node_modules tmp && \
    apk del yarn nodejs

CMD ./bin/app-startup.sh