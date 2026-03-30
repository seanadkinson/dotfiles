#!/usr/bin/env bash

stripe listen --forward-to http://localhost:3000/app/billing/webhook

