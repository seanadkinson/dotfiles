#!/bin/bash

# Check if AWS profile is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <AWS_PROFILE>"
  exit 1
fi

AWS_PROFILE=$1

# Get the current external IP address
MY_IP=$(curl -s http://checkip.amazonaws.com)
echo "Current IP Address: $MY_IP"

# Define variables for security group and port
SECURITY_GROUP_NAME="slt-db"
PORT=3306

# Get the security group ID
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --profile $AWS_PROFILE --filters "Name=group-name,Values=$SECURITY_GROUP_NAME" --query "SecurityGroups[0].GroupId" --output text)

if [ "$SECURITY_GROUP_ID" == "None" ]; then
  echo "Security group $SECURITY_GROUP_NAME not found."
  exit 1
fi

echo "Security Group ID: $SECURITY_GROUP_ID"

# Get all security group rules for the security group
SECURITY_GROUP_RULES=$(aws ec2 describe-security-group-rules --profile $AWS_PROFILE --filters "Name=group-id,Values=$SECURITY_GROUP_ID" --query "SecurityGroupRules" --output json)

# Find the rule IDs for the current IP permissions for the specified port
RULE_IDS=$(echo $SECURITY_GROUP_RULES | jq -r ".[] | select(.IpProtocol == \"tcp\" and .FromPort == $PORT and .ToPort == $PORT and .CidrIpv4 != null) | .SecurityGroupRuleId")

if [ -n "$RULE_IDS" ]; then
  # Revoke previous rules for port 3306
  aws ec2 revoke-security-group-ingress --profile $AWS_PROFILE --group-id $SECURITY_GROUP_ID --security-group-rule-ids $RULE_IDS
fi

# Add new rule for current IP
aws ec2 authorize-security-group-ingress --profile $AWS_PROFILE --group-id $SECURITY_GROUP_ID --protocol tcp --port $PORT --cidr "$MY_IP/32"

echo "Security group updated to allow access to port $PORT from IP address $MY_IP"
