FROM numidiasoft/node
MAINTAINER Tarik Ihadjadene

RUN npm install -g bower
RUN npm install -g gulp

RUN rm -r /var/lib/apt/lists/* \
    && apt-get update \
    && apt-get upgrade \
    && apt-get install ruby1.9.1 ruby1.9.1-dev -y

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

RUN echo 'export LC_CTYPE=en_US.UTF-8' >> /etc/bash.bashrc 
RUN echo 'export LANG=en_US.UTF-8' >> /etc/bash.bashrc
RUN echo 'export unset LC_ALL' >> /etc/bash.bashrc
  
RUN gem install compass

# Prepare the work directory
VOLUME ["/app", "/app/node_modules", "/app/bower_components"]
WORKDIR /app

COPY ./bin/start.sh /start.sh
RUN chmod u+x /start.sh


# Add the application entrypoint

CMD /start.sh
