FROM grappendorf/ruby:2.2.1
MAINTAINER Dirk Grappendorf "dirk@grappendorf.net"

ENV LAST_APT_GET_UPDATE 20150311
RUN apt-get update -qqy
RUN apt-get install -qqy libsqlite3-dev

ENV RAILS_ENV production

ADD . /var/app
WORKDIR /var/app

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
