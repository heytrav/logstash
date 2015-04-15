#!/bin/bash


sed -i 's/LUMBERJACK_SERVICE_PORT/'"$LUMBERJACK_SERVICE_PORT"'/g' /etc/logstash/conf.d/syslog.conf


/usr/bin/supervisord
