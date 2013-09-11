#!/usr/bin/env bash
set -e

if [ -f .env ]; then
  export $(cat .env | grep -v ^# | xargs);
fi

git up

if [ -f ./package.json ]; then
  if [ -f ./yarn.lock ]; then
    yarn install --pure-lockfile
    yarn start
  else
    npm install
    npm start
  fi
else
  ./gradlew dbMigrate runShadow
fi

