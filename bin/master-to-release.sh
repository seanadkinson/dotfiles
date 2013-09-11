#!/usr/bin/env bash
set -e
set -x

git checkout release;
git up;
git merge --ff-only master;
git push -u;
git checkout master;

