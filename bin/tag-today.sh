#!/usr/bin/env bash
set -e

DOT_DATE=`date +%Y.%m.%d`
DASH_DATE=`date +%Y-%m-%d`
git tag -a "v$DOT_DATE$2" -m "Updated prod on $DASH_DATE" $1
git push --tags $1

echo ""
echo "Created and pushed tag v$DOT_DATE$2"
echo ""
