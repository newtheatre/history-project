ARG RUBY_VERSION=2.4.10
ARG NODE_VERSION=10.16.0

FROM ruby:${RUBY_VERSION}

WORKDIR /app

COPY . .

RUN gem install bundler -v 2.3.27 \
    && bundle install

RUN apt-get -y update \
    && apt-get -y upgrade

# I hate this.

RUN apt-get -y install npm

RUN npm cache clean -f

RUN npm install -g n \
    && n 10.16.0