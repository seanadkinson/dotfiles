#!/usr/bin/env bash

sudo discoveryutil mdnsflushcache
sudo killall -HUP mDNSResponder
sudo dscacheutil -flushcache
