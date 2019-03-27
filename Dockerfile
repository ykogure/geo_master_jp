FROM ruby:2.5.1
ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    ENTRYKIT_VERSION=0.4.0

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && \
    apt-get install -y build-essential nodejs

RUN mkdir /app
WORKDIR /app

ADD Gemfile .
ADD Gemfile.lock .

ADD . .
