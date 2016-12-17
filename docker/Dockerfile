FROM ruby:2.3.2
MAINTAINER Dirk Grappendorf "dirk@grappendorf.net"

RUN apt-get update -qqy
RUN apt-get install -qqy build-essential libxml2-dev libxslt-dev libsqlite3-dev
COPY docker/run.sh /bin/

ENV RACK_ENV production
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1

COPY app /var/app/app/
COPY config /var/app/config/
COPY db /var/app/db/
COPY lib /var/app/lib/
COPY Gemfile Rakefile config.ru .ruby-* /var/app/
WORKDIR /var/app

RUN echo "gem: --no-document" > /root/.gemrc
RUN bundle install --without=development test
RUN rake db:drop
RUN rake db:migrate
RUN rake db:seed

VOLUME /var/app/db/sqlite
VOLUME /root/.hue-lib

EXPOSE 3000
EXPOSE 2000/udp
EXPOSE 55555/udp

ENTRYPOINT ["run.sh"]
