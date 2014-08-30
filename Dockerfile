FROM debian:jessie

MAINTAINER Yorimoto Komori

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y curl ruby && gem install bundler
RUN apt-get install -y ruby-ffi ruby-nokogiri ruby-redcarpet ruby-rmagick ruby-mysql2 unicorn

RUN curl -L http://www.redmine.org/releases/redmine-2.5.2.tar.gz | tar -zx && mv redmine-2.5.2 /var/lib/redmine && chown -R root. /var/lib/redmine
WORKDIR /var/lib/redmine

COPY config/ /var/lib/redmine/config/
RUN useradd -s /bin/nologin redmine && \
  chown redmine files && \
  sed -i -e 's/gem "redcarpet", "~> 2.3.0"/gem "redcarpet", "~> 3.1"/g' Gemfile && \
  echo 'gem "unicorn"' >> Gemfile && \
  bundle install --without development test rmagick

CMD /bin/sh config/startup.sh

EXPOSE 8080
