FROM dockerfile/java:oracle-java8
MAINTAINER Travis Holton <travis@ideegeo.com>

RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

ENV LOGSTASH_VERSION 1.4.2

# Install Required Dependancies
RUN \
  apt-get -qq update && \
  apt-get -qy install wget --no-install-recommends && \
  apt-get -qq update && \
  apt-get -qy install supervisor \
                      curl \
                      unzip \
                      inotify-tools && \
  apt-get -y autoremove && \
  apt-get autoclean && cd / && \
  curl -O https://download.elasticsearch.org/logstash/logstash/logstash-$LOGSTASH_VERSION.tar.gz && \
  tar zxf logstash-$LOGSTASH_VERSION.tar.gz && \
  mv logstash-$LOGSTASH_VERSION /opt/logstash && \
  rm -f logstash-$LOGSTASH_VERSION.tar.gz && \
  cd /opt && \
  curl -O http://download.elasticsearch.org/logstash/logstash/logstash-contrib-$LOGSTASH_VERSION.tar.gz && \
  tar xzf  logstash-contrib-$LOGSTASH_VERSION.tar.gz -C logstash --strip-components=1 && \
  rm -f logstash-contrib-$LOGSTASH_VERSION.tar.gz

ADD supervisord.conf /etc/supervisor/conf.d/
ADD crons/ /etc/cron.hourly/

ADD logstash/ /etc/logstash/

VOLUME ["/etc/logstash/conf.d"]

EXPOSE 22 5043 25826 
WORKDIR /usr/local
ADD docker_start.sh /usr/local/

CMD ["./docker_start.sh"]
