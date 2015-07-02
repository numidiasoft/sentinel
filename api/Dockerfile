FROM ruby:2.1.6
MAINTAINER Tarik Ihadjadene

# Prepare the work directory
VOLUME ["/app", "/.bundle"]
WORKDIR /app

COPY ./bin/start.sh /start.sh
RUN chmod u+x /start.sh

RUN bundle config path /.bundle

# Add the application entrypoint

CMD /start.sh


