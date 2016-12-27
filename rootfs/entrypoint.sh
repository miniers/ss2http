#!/bin/sh

#------------------------------------------------------------------------------
# Configure the service:
#------------------------------------------------------------------------------
env /usr/local/bin/ss-local -s $SERVER_ADDR -p $SERVER_PORT -k $PASSWORD \
  -b 0.0.0.0 -l ${LOCAL_PORT:-8124} -m ${METHOD:-'chacha20'} \
  -d start

env /usr/sbin/privoxy --no-daemon /etc/privoxy/config