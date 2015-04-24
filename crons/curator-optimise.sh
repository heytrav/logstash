#!/bin/bash

curator --host 127.0.0.1 optimize --older-than $ES_CURATOR_OPTIMISE_DAYS
