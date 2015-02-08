FROM ubuntu:trusty
MAINTAINER Travis Holton <travis@ideegeo.com>


MAINTAINER Travis Holton <travis@ideegeo.com>

RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

ENV LOGSTASH_VERSION 1.4.2

# Install Required Dependancies
RUN \
  apt-get -qq update && \
  apt-get -qy install wget --no-install-recommends && \
  wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
  echo 'deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main' \
    >> /etc/apt/sources.list && \
  echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' \
    >> /etc/apt/sources.list && \
  apt-get -qq update && \
  apt-get -qy install supervisor \
                      logstash \
                      curl \
                      python-pip \
                      unzip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install logstash contributed libraries
ADD http://download.elasticsearch.org/logstash/logstash/logstash-contrib-$LOGSTASH_VERSION.tar.gz /opt/
RUN \
  cd /opt && tar xvzf  logstash-contrib-$LOGSTASH_VERSION.tar.gz -C logstash --strip-components=1 && \
  pip install -I elasticsearch-curator &&  \
  mkdir -p /etc/logstash/{patterns,conf.d} && \
  rm -fr /tmp/pip-* 

ADD supervisord.conf /etc/supervisor/conf.d/
ADD crons/ /etc/cron.hourly/

ADD logstash/* /etc/logstash/

VOLUME ["/etc/logstash/conf.d"]

EXPOSE 80 443

CMD ["/usr/bin/supervisord"]
