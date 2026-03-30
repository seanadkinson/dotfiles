#!/usr/bin/env bash
set -e

gh pr create --base release --head main --title "Release $(date '+%b %-d, %Y')"

