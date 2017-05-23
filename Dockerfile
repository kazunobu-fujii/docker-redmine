FROM ruby:2.3.1

MAINTAINER Miraitechno, Inc.

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y unzip
RUN curl -L http://www.redmine.org/releases/redmine-3.3.0.tar.gz | tar -zx && mv redmine-3.3.0 /var/lib/redmine && chown -R root. /var/lib/redmine

WORKDIR /var/lib/redmine/public/themes
RUN git clone git://github.com/makotokw/redmine-theme-gitmike.git gitmike
RUN git clone git://github.com/farend/redmine_theme_farend_basic.git farend_basic
RUN git clone git://github.com/farend/redmine_theme_farend_fancy.git farend_fancy

WORKDIR /var/lib/redmine
RUN echo 'production:\n  adapter: mysql2' >> config/database.yml && \
    echo 'gem "unicorn"' >> Gemfile && \
    bundle install --without development test rmagick
RUN useradd -m -s /bin/nologin redmine && \
    chown -R redmine files tmp public/plugin_assets
RUN echo 'ActionController::Base.relative_url_root = ENV["URL_ROOT"] if ENV["URL_ROOT"]' >> config/environment.rb && \
    sed -i -e 's/^run /#run /' config.ru && \
    echo 'map ActionController::Base.relative_url_root || "/" do\n  run RedmineApp::Application\nend' >> config.ru
COPY config/ /var/lib/redmine/config/

CMD HOME=/home/redmine /bin/sh config/startup.sh
ENV REDMINE_LANG en
EXPOSE 8080
