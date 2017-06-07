#!/usr/bin/env bash

response=$(curl -u ethan-berg:wCN0gA2ZA6w3XCxs02YoY5MAwQQFkeRh9ojQUMLd_sU -X POST -H 'Accept: application/vnd.snap-ci.com.v1+json' https://api.snap-ci.com/project/odysseyscience/hthu-automation/branch/master/trigger)
counter=$(echo $response | jsawk 'return this.counter')
curl -u ethan-berg:wCN0gA2ZA6w3XCxs02YoY5MAwQQFkeRh9ojQUMLd_sU -X POST -H 'Accept: application/vnd.snap-ci.com.v1+json' https://api.snap-ci.com/project/odysseyscience/hthu-automation/branch/master/trigger/{$counter}/Test