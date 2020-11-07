FROM ruby:2.7.1-alpine AS pre-builder

ARG BUNDLE_WITHOUT="development:test"
ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}
ENV BUNDLER_VERSION=2.1.2

ARG RAILS_SERVE_STATIC_FILES=true
ENV RAILS_SERVE_STATIC_FILES ${RAILS_SERVE_STATIC_FILES}

ARG RAILS_ENV=production
ENV RAILS_ENV ${RAILS_ENV}

ENV BUNDLE_PATH="/gems"

RUN apk update \
  && apk add \
    openssl \
    tar \
    build-base \
    tzdata \
    git \
  && mkdir -p /var/app \
  && gem install bundler

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

# Do not install development or test gems in production
RUN if [ "$RAILS_ENV" = "production" ]; then \
  bundle config set without 'development test'; bundle install -j 4 -r 3; \
  else bundle install -j 4 -r 3; \
  fi

COPY . /app

# final build stage
FROM ruby:2.7.1-alpine

ARG BUNDLE_WITHOUT="development:test"
ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}
ENV BUNDLER_VERSION=2.1.2

ARG EXECJS_RUNTIME="Disabled"
ENV EXECJS_RUNTIME ${EXECJS_RUNTIME}

ARG RAILS_SERVE_STATIC_FILES=true
ENV RAILS_SERVE_STATIC_FILES ${RAILS_SERVE_STATIC_FILES}

ARG RAILS_ENV=production
ENV RAILS_ENV ${RAILS_ENV}
ENV BUNDLE_PATH="/gems"

RUN apk add --update --no-cache \
    openssl \
    tzdata \
  && gem install bundler

COPY --from=pre-builder /gems/ /gems/
COPY --from=pre-builder /app /app

RUN rm -rf /gems/ruby/2.7.0/cache/*.gem \
  && find /gems/ruby/2.7.0/gems/ -name "*.c" -delete \
  && find /gems/ruby/2.7.0/gems/ -name "*.o" -delete

RUN mkdir -p /app/log

WORKDIR /app