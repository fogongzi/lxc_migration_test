#!/bin/bash


netperf -H 10.0.3.13 -l 600 -t TCP_STREAM -- -m 204800
sleep 50