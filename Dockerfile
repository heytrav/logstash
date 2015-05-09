FROM java:8u45-jre
MAINTAINER Travis Holton <travis@ideegeo.com>

RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

ENV LOGSTASH_VERSION 1.5.0-rc4

# Install latest Java
#RUN apt-get -qq update && \
    #apt-get -qy install software-properties-common && apt-get -qq update
#RUN add-apt-repository -y ppa:webupd8team/java && apt-get -qq update
#RUN apt-get -qy install oracle-java8-installer

# Install Required Dependancies
RUN apt-get -qq update && \
    apt-get -qy install  wget --no-install-recommends  \
                      supervisor \
                      python-pip \
                      curl \
                      unzip \
                      inotify-tools
RUN pip install -I elasticsearch-curator
RUN apt-get -y autoremove apt-get autoclean 

RUN cd / && \
  curl -O https://download.elasticsearch.org/logstash/logstash/logstash-$LOGSTASH_VERSION.tar.gz && \
  tar zxf logstash-$LOGSTASH_VERSION.tar.gz && \
  mv logstash-$LOGSTASH_VERSION /opt/logstash && \
  rm -f logstash-$LOGSTASH_VERSION.tar.gz

RUN cd /opt/logstash && bin/plugin install logstash-filter-elapsed 

ADD supervisord.conf /etc/supervisor/conf.d/
ADD crons /etc/cron.hourly/
ADD logstash /etc/logstash/

VOLUME ["/etc/logstash/conf.d"]

EXPOSE 22 5043 9200 9300 25826 
WORKDIR /usr/local
ADD docker_start.sh /usr/local/

CMD ["./docker_start.sh"]
