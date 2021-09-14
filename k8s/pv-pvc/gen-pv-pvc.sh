#!/usr/bin/env bash

# /home/raiven/go/bin/gomplate -d 'data=./pv-pvc.yaml' -f pv-pvc.tmpl 

APP_NAME="influxdb2"
NAMESPACE="monitoring"
STORAGE_PATH="/home/raiven/influxdb2"
STORAGE="5Gi"

ARGS="{\"APP_NAME\":\"${APP_NAME}\", \"NAMESPACE\":\"$NAMESPACE\", \"STORAGE_PATH\":\"$STORAGE_PATH\", \"STORAGE\":\"$STORAGE\"}"
echo $ARGS | gomplate -d data=stdin:///in.json -o pv-pvc-$APP_NAME.yaml -f pv-pvc.tmpl