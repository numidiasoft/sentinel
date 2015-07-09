FROM numidiasoft/ruby:2.1.6
MAINTAINER Tarik Ihadjadene

# Prepare the work directory
VOLUME ["/app", "/.bundle"]
WORKDIR /app

COPY ./bin/start.sh /start.sh
COPY ./bin/cron /cron
RUN chmod u+x /start.sh

RUN gem install bundler
RUN bundle config path /.bundle

# Add the application entrypoint

CMD /start.sh


