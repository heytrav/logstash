FROM java:openjdk-8u45-jre
MAINTAINER Travis Holton <travis@ideegeo.com>

RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

ENV LOGSTASH_VERSION 1.5.1


# Install Required Dependancies
RUN apt-get -qq update && \
    apt-get -qy install  wget --no-install-recommends  \
                      supervisor \
                      python-pip \
                      curl \
                      openssh-server \
                      unzip \
                      inotify-tools
RUN mkdir -p /var/run/sshd
RUN apt-get -y autoremove

RUN cd / && \
  curl -O https://download.elasticsearch.org/logstash/logstash/logstash-$LOGSTASH_VERSION.tar.gz && \
  tar -zxf logstash-$LOGSTASH_VERSION.tar.gz && \
  mv logstash-$LOGSTASH_VERSION /opt/logstash && \
  rm -f logstash-$LOGSTASH_VERSION.tar.gz

RUN cd /opt/logstash && bin/plugin install logstash-filter-elapsed 

ADD supervisord.conf /etc/supervisor/conf.d/
ADD logstash /etc/logstash/

VOLUME ["/etc/logstash/conf.d"]

EXPOSE 22 5043 9200 9300 25826 
WORKDIR /usr/local
ADD docker_start.sh /usr/local/

CMD ["./docker_start.sh"]
