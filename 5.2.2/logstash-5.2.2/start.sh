#!/usr/bin/env bash
nohup bin/logstash -f config/first-pipeline.conf --config.reload.automatic &> nohup.out & echo $! > logstash.pid