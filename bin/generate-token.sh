#!/usr/bin/env bash
set -e

postfix="$1"
domain="$2"
environment="$3"
source_service="$4"
destination_service="$5"
scope="$6"

print_usage() { 
  echo "Usage: generate-token.sh [postfix] [domain] [infrastructure_environment] [source_service] [destination_service] [scope]"
} 

if [ "$postfix" = "" -o "$domain" = "" -o "$environment" = "" -o "$source_service" = "" -o "$destination_service" = "" -o "$scope" = "" ]; then
  print_usage
  exit 1
fi

signingPath="infrastructure/environments/$environment/secret-*-platform-auth-signing-jwk.json"
subject="https://$source_service.$domain.streem.cloud/"
audience="https://$destination_service.$domain.streem.cloud/"
issuer="https://auth.$domain.streem.cloud/"

if [ ! -f $signingPath ]; then
  echo "Unable to locate jwk at: $signingPath"
  exit 1
fi\

echo "Generating Token"
echo "  Postfix: $postfix"
echo "  Domain: $domain"
echo "  Subject: $subject"
echo "  Audience: $audience"
echo "  Issuer: $issuer"
echo "  Scope: $scope"
echo "  Signing Path: $signingPath"
echo ""

docker-compose run --rm --no-deps \
    -e PLATFORM_AUTH_SIGNING_KEY_ENCODED=$(base64 -i $signingPath) \
    -e DOMAIN=$domain.streem.cloud \
    -e ENV_POSTFIX=$postfix \
    auth generate-token \
    -d "P3650D" \
    --subject $subject \
    --audience $audience \
    --issuer $issuer \
    --scope $scope \
    /service.yml
