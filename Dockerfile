FROM grappendorf/ruby:2.1.5
MAINTAINER Dirk Grappendorf "dirk@grappendorf.net"

# Database drivers
RUN apt-get install -y libpq-dev

# Add application
ADD . /opt/app
WORKDIR /opt/app
RUN rm -rf tmp

# Production environment, context path
ENV RAILS_ENV production
ENV RAILS_RELATIVE_URL_ROOT /coyoho

# Install gems, compile assets, link for sub uri
RUN bundle install --without=development test demo
RUN ln -s public coyoho

# Link log directory to /var/log/app
RUN rm -rf log
RUN ln -s /var/log/app log

ADD docker/start.sh /usr/local/bin/

EXPOSE 80

ENTRYPOINT ["start.sh"]
