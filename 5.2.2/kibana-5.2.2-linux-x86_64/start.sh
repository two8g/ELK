#!/usr/bin/env bash
nohup bin/kibana &> nohup.out & echo $! > kibana.pid