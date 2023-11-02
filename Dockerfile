FROM ruby:slim-bullseye as base

RUN apt update
RUN apt install -y \
    tzdata \
    build-essential \
    libmysqld-dev \
    git

RUN mkdir /app
WORKDIR /app

ADD Gemfile .
ADD Gemfile.lock .

ADD . .
