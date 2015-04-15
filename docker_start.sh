#!/bin/bash


sed -i 's/LUMBERJACK_SERVICE_PORT/'"$LUMBERJACK_SERVICE_PORT"'/g' /etc/logstash/conf.d/syslog.conf
sed -i 's/ELASTICSEARCH_SERVICE_HOST/'"$ELASTICSEARCH_SERVICE_HOST"'/g' /etc/logstash/conf.d/syslog.conf


/usr/bin/supervisord
