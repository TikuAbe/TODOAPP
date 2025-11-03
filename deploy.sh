#!/bin/bash

# Deploy TODOD App Infrastructure
# Usage: ./deploy.sh <stack-name> <key-pair-name> <on-premises-cidr> <your-public-ip>

STACK_NAME=${1:-tododapp-infrastructure}
KEY_PAIR_NAME=${2:-my-key-pair}
ON_PREMISES_CIDR=${3:-10.0.0.0/16}
YOUR_PUBLIC_IP=${4:-1.2.3.4}

echo "Deploying CloudFormation stack: $STACK_NAME"
echo "Key Pair: $KEY_PAIR_NAME"
echo "On-premises CIDR: $ON_PREMISES_CIDR"
echo "Your Public IP: $YOUR_PUBLIC_IP"

# Update the Customer Gateway IP in the template
sed -i "s/IpAddress: 1.2.3.4/IpAddress: $YOUR_PUBLIC_IP/" infrastructure.yaml

# Deploy the stack
aws cloudformation deploy \
  --template-file infrastructure.yaml \
  --stack-name $STACK_NAME \
  --parameter-overrides \
    KeyPairName=$KEY_PAIR_NAME \
    OnPremisesCIDR=$ON_PREMISES_CIDR \
  --capabilities CAPABILITY_IAM \
  --region us-east-1

echo "Deployment initiated. Check AWS Console for progress."
echo "After deployment, configure your on-premises VPN device with the connection details."