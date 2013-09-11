#!/usr/bin/env bash
system_profiler SPUSBDataType | grep -A 10 iPhone | grep Serial
