FROM ruby:2.2.4
MAINTAINER Dirk Grappendorf "dirk@grappendorf.net"

RUN apt-get update -qqy
RUN apt-get install -qqy build-essential libxml2-dev libxslt-dev libsqlite3-dev

ENV RAILS_ENV production
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1

ADD . /var/app
WORKDIR /var/app

RUN echo "gem: --no-document" > /root/.gemrc
RUN bundle install --without=development test demo
RUN rake db:migrate
RUN rake db:seed
RUN ln -s public caretaker

ADD docker/start.sh /bin/

VOLUME /var/app/db/sqlite
VOLUME /root/.hue-lib

EXPOSE 3000
EXPOSE 2000/udp
EXPOSE 55555/udp

ENTRYPOINT ["start.sh"]
