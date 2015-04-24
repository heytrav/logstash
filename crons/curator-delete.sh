#!/bin/bash

curator --host 127.0.0.1 delete --older-than $ES_CURATOR_DELETE_DAYS
