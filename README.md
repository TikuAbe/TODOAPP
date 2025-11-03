# TODOD App AWS Infrastructure

This CloudFormation template creates infrastructure to host your TODOD application on an EC2 instance in a private subnet with VPN connectivity to your on-premises data center.

## Architecture

- **VPC**: 172.16.0.0/16
- **Private Subnet**: 172.16.1.0/24
- **EC2 Instance**: In private subnet, accessible only from on-premises
- **VPN Connection**: Site-to-site VPN between AWS and on-premises
- **Security Group**: Restricts access to on-premises CIDR only

## Prerequisites

1. AWS CLI configured with appropriate permissions
2. EC2 Key Pair created in your target region
3. Your public IP address for the Customer Gateway
4. On-premises network CIDR block

## Deployment

### Option 1: Using the deployment script

```bash
chmod +x deploy.sh
./deploy.sh <stack-name> <key-pair-name> <on-premises-cidr> <your-public-ip>
```

Example:
```bash
./deploy.sh tododapp-prod my-keypair 10.0.0.0/16 203.0.113.1
```

### Option 2: Manual deployment

1. Update the Customer Gateway IP in `infrastructure.yaml`:
   ```yaml
   IpAddress: YOUR_PUBLIC_IP  # Replace with your actual public IP
   ```

2. Deploy using AWS CLI:
   ```bash
   aws cloudformation deploy \
     --template-file infrastructure.yaml \
     --stack-name tododapp-infrastructure \
     --parameter-overrides \
       KeyPairName=your-key-pair \
       OnPremisesCIDR=10.0.0.0/16 \
     --capabilities CAPABILITY_IAM
   ```

## Post-Deployment Steps

1. **Configure VPN on your on-premises device**:
   - Get VPN connection details from AWS Console
   - Configure your firewall/router with the provided tunnel information

2. **Access your EC2 instance**:
   - Use AWS Systems Manager Session Manager (recommended)
   - Or SSH from on-premises network: `ssh -i your-key.pem ec2-user@<private-ip>`

3. **Deploy your application**:
   - The instance comes with Docker pre-installed
   - Add your application deployment commands to the UserData section

## Security Features

- EC2 instance in private subnet (no direct internet access)
- Security group allows traffic only from on-premises CIDR
- VPN encryption for all traffic between AWS and on-premises
- IAM role with minimal required permissions

## Customization

- Update the AMI ID for your preferred region
- Modify security group rules for your application ports
- Adjust instance type based on your requirements
- Add additional subnets for high availability

## Troubleshooting

- Ensure your on-premises firewall allows VPN traffic
- Verify route propagation is working
- Check VPN tunnel status in AWS Console
- Use VPC Flow Logs to debug connectivity issues