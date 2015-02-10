#!/bin/bash


sed -i 's/ELASTICSEARCH_TRANSPORT/$ELASTICSEARCH_TRANSPORT/g' /etc/logstash/conf.d/syslog.conf


/usr/bin/supervisord --no-daemon
