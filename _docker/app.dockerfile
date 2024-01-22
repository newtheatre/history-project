ARG RUBY_VERSION=2.4.0

FROM ruby:${RUBY_VERSION}

WORKDIR /app

COPY . .

RUN bundle install

RUN apt-get -y update \
    && apt-get upgrade \
    && apt-get install -y n \
    && n 10.16.0