FROM grappendorf/ruby:2.1.5
MAINTAINER Dirk Grappendorf "dirk@grappendorf.net"

ENV LAST_APT_GET_UPDATE 20150311
RUN apt-get update -qqy
RUN apt-get install -qqy libpq-dev libsqlite3-dev

ADD . /var/app
WORKDIR /var/app
RUN rm -rf db/*.sqlite3
RUN rm -rf tmp/*
RUN rm -rf log/*

ENV RAILS_ENV production
#ENV RAILS_RELATIVE_URL_ROOT /caretaker

RUN bundle install --without=development test demo
RUN rake db:migrate
RUN rake db:seed
RUN ln -s public caretaker

ADD docker/start.sh /bin/

VOLUME /var/app/db

EXPOSE 3000
EXPOSE 2000/udp
EXPOSE 55555/udp

ENTRYPOINT ["start.sh"]
