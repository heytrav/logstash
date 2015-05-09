FROM dockerfile/java:oracle-java8
MAINTAINER Travis Holton <travis@ideegeo.com>

RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

ENV LOGSTASH_VERSION 1.5.0-rc4

# Install Required Dependancies
RUN \
  apt-get -qq update && \
  apt-get -qy install wget --no-install-recommends && \
  apt-get -qq update && \
  apt-get -qy install supervisor \
                      python-pip \
                      curl \
                      unzip \
                      inotify-tools && \
  pip install -I elasticsearch-curator &&  \
  apt-get -y autoremove && \
  apt-get autoclean && cd / && \
  curl -O https://download.elasticsearch.org/logstash/logstash/logstash-$LOGSTASH_VERSION.tar.gz && \
  tar zxf logstash-$LOGSTASH_VERSION.tar.gz && \
  mv logstash-$LOGSTASH_VERSION /opt/logstash && \
  rm -f logstash-$LOGSTASH_VERSION.tar.gz

RUN cd /opt/logstash && bin/plugin install logstash-filter-elapsed

ADD supervisord.conf /etc/supervisor/conf.d/
ADD crons /etc/cron.hourly/
ADD logstash /etc/logstash/

VOLUME ["/etc/logstash/conf.d"]

EXPOSE 22 5043  25826
WORKDIR /usr/local
ADD docker_start.sh /usr/local/

CMD ["./docker_start.sh"]
