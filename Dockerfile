FROM grappendorf/ruby:2.1.5
MAINTAINER Dirk Grappendorf "dirk@grappendorf.net"

ENV LAST_APT_GET_UPDATE 20150311
RUN apt-get update -qqy
RUN apt-get install -qqy libsqlite3-dev
RUN apt-get install -qqy curl
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -qqy nodejs

ENV RAILS_ENV production
#ENV RAILS_RELATIVE_URL_ROOT /caretaker

ADD . /var/app
WORKDIR /var/app
RUN rm -rf db/sqlite/*
RUN rm -rf tmp/*
RUN rm -rf log/*

RUN npm install
RUN ./bin/bower --allow-root install
RUN ./bin/grunt build
RUN bundle install --without=development test demo
RUN rake db:migrate
RUN rake db:seed
RUN ln -s public caretaker

ADD docker/start.sh /bin/

VOLUME /var/app/db/sqlite

EXPOSE 3000
EXPOSE 2000/udp
EXPOSE 55555/udp

ENTRYPOINT ["start.sh"]
