#!/bin/bash

curator --host $ELASTICSEARCH_LB_SERVICE_HOST delete --older-than $ES_CURATOR_DELETE_DAYS
