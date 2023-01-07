##### THIS SCRIPT CREATES A VPC AND SETS UP A LOAD BALANCER TO TARGET REPLICAS IN A PRIVATE SUBNET #####

# Creating a VPC

VPC_CIDR='120.10.0.0/16'
KEY_NAME='altschool-server-key'

echo "STEP 1..."
echo
echo "creating VPC..."
VPC=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --tag-specification 'ResourceType=vpc,Tags=[{Key=Name,Value=altschool-project-vpc}]')
VPC_ID=$(echo $VPC | jq -r .Vpc.VpcId)
echo $VPC | jq -r
echo 'vpc-id = ' $VPC_ID
echo "done..."
echo "=================="

echo "## SETUP IDs ##" >vars.sh
echo "export VPC_ID=$VPC_ID" >>vars.sh

# Creating 3 subnets
echo "STEP 2..."
echo
echo "Creating 3 subnets"
echo ">>==============<<"

echo "Creating subnet 1"
SUBNET1=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID --cidr-block 120.10.1.0/24 \
  --availability-zone us-east-1a \
  --tag-specification 'ResourceType=subnet,Tags=[{Key=Name,Value=altschool-project-subnet-1-public}]')
SUBNET1_ID=$(echo $SUBNET1 | jq -r .Subnet.SubnetId)
echo $SUBNET1 | jq -r
echo 'public-subnet-id = ' $SUBNET1_ID
echo "=================="

echo "Creating subnet 2"
SUBNET2=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID --cidr-block 120.10.2.0/24 \
  --availability-zone us-east-1a \
  --tag-specification 'ResourceType=subnet,Tags=[{Key=Name,Value=altschool-project-subnet-2-private}]')
SUBNET2_ID=$(echo $SUBNET2 | jq -r .Subnet.SubnetId)
echo $SUBNET2 | jq -r
echo 'private-subnet-1-id = ' $SUBNET2_ID
echo "done..."
echo "=================="
echo

echo "Creating subnet 3"
SUBNET3=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID --cidr-block 120.10.3.0/24 \
  --availability-zone us-east-1b \
  --tag-specification 'ResourceType=subnet,Tags=[{Key=Name,Value=altschool-project-subnet-3-public}]')
SUBNET3_ID=$(echo $SUBNET3 | jq -r .Subnet.SubnetId)
echo $SUBNET3 | jq -r
echo 'private-subnet-2-id = ' $SUBNET3_ID
echo "done..."
echo "=================="
echo

echo "export SUBNET1_ID=$SUBNET1_ID" >>vars.sh
echo "export SUBNET2_ID=$SUBNET2_ID" >>vars.sh
echo "export SUBNET3_ID=$SUBNET3_ID" >>vars.sh

## Create an Internet Gateway
echo "STEP 3..."
echo
echo "creating internet gateway for VPC..."
IGW=$(aws ec2 create-internet-gateway --tag-specification 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=altschool-project-igw}]')
IGW_ID=$(echo $IGW | jq -r .InternetGateway.InternetGatewayId)
echo $IGW | jq -r
echo 'igw-id = ' $IGW_ID
echo "done..."
echo "=================="
echo

echo "export IGW_ID=$IGW_ID" >>vars.sh

## Attaching internet gateway to VPC
echo "STEP 4..."
echo
echo "Attaching internet gateway to VPC..."
attach_ig=$(aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID)
echo "attach_ig = " $attach_ig
echo "done..."
echo "=================="
echo

## Create a custom route table
echo "STEP 5..."
echo
echo "creating route table for public subnets in VPC..."
RTB=$(aws ec2 create-route-table --vpc-id $VPC_ID --tag-specification 'ResourceType=route-table,Tags=[{Key=Name,Value=altschool-project-rtb}]')
RTB_ID=$(echo $RTB | jq -r .RouteTable.RouteTableId)
echo $RTB | jq -r
echo 'rtb-id = ' $RTB_ID
echo "done..."
echo "=================="
echo

echo "export RTB_ID=$RTB_ID" >>vars.sh

## Creating route in route table for VPC
echo "STEP 6..."
echo
echo "Creating route in route table for VPC..."
RT_STATE=$(aws ec2 create-route --route-table-id $RTB_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID)
echo 'rt-state = '
echo $RT_STATE | jq -r
echo "done..."
echo "=================="
echo

## Check route has been created and is active
echo "STEP 7..."
echo
echo "describing route in route table for VPC..."
describe_RTB=$(aws ec2 describe-route-tables --route-table-id $RTB_ID)
echo 'rtb-state =v'
echo $describe_RTB | jq -r
echo "done..."
echo "=================="
echo

## Associate subnet with custom route table to make public
echo "STEP 8..."
echo
echo "Associate subnet with custom route table to make public..."
RTB_ASSOC1=$(aws ec2 associate-route-table --subnet-id $SUBNET1_ID --route-table-id $RTB_ID)
RTB_ASSOC2=$(aws ec2 associate-route-table --subnet-id $SUBNET3_ID --route-table-id $RTB_ID)
RTB_ASSOC_ID_1=$(echo $RTB_ASSOC1 | jq -r .AssociationId)
RTB_ASSOC_ID_2=$(echo $RTB_ASSOC2 | jq -r .AssociationId)
echo $RTB_ASSOC | jq -r
echo 'rtb-assoc-id-1 = ' $RTB_ASSOC_ID_1
echo 'rtb-assoc-id-2 = ' $RTB_ASSOC_ID_2
echo "done..."
echo "=================="
echo

echo "export RTB_ASSOC_ID_1=$RTB_ASSOC_ID1_" >>vars.sh
echo "export RTB_ASSOC_ID_2=$RTB_ASSOC_ID_2" >>vars.sh

## Configure subnet to issue a public IP to EC2 instances
echo "STEP 9..."
echo
echo "Configure subnet to issue a public IP to EC2 instances..."
SUBNET1_MOD=$(aws ec2 modify-subnet-attribute --subnet-id $SUBNET1_ID --map-public-ip-on-launch)
SUBNET3_MOD=$(aws ec2 modify-subnet-attribute --subnet-id $SUBNET3_ID --map-public-ip-on-launch)
echo "subnet 1 modified => " $SUBNET1_MOD
echo "subnet 3 modified => " $SUBNET3_MOD
echo "done..."
echo "=================="
echo

## Create an Elastic IP  for NAT Gateway
echo "STEP 10..."
echo
echo "Create an Elastic IP  for NAT Gateway..."
EIP=$(
  aws ec2 allocate-address \
    --tag-specification 'ResourceType=elastic-ip,Tags=[{Key=Name,Value=altschool-project-eip}]'
)
EIP_IP=$(echo $EIP | jq -r .PublicIp)
EIP_ALLOC_ID=$(echo $EIP | jq -r .AllocationId)
echo $EIP | jq -r
echo 'eip-ip = ' $EIP_IP
echo 'eip-alloc-id = ' $EIP_ALLOC_ID
echo "done..."
echo "=================="
echo

echo "export EIP_IP=$EIP_IP" >>vars.sh
echo "export EIP_ALLOC_ID=$EIP_ALLOC_ID" >>vars.sh

## Create NAT Gateway for private subnet in public subnet
echo "STEP 11..."

echo "Create NAT Gateway for private subnet in public subnet..."
NAT=$(
  aws ec2 create-nat-gateway \
    --subnet-id $SUBNET1_ID \
    --allocation-id $EIP_ALLOC_ID \
    --tag-specification 'ResourceType=natgateway,Tags=[{Key=Name,Value=altschool-project-nat}]'
)
NAT_ID=$(echo $NAT | jq -r .NatGateway.NatGatewayId)
echo $NAT | jq -r
echo 'nat-gateway-id = ' $NAT_ID
echo "done..."
echo "=================="
echo

echo "export NAT_ID=$NAT_ID" >>vars.sh

echo "STEP 11.1..."
echo
echo "creating route table for private subnets in VPC..."
RTB_PRIV=$(aws ec2 create-route-table --vpc-id $VPC_ID --tag-specification 'ResourceType=route-table,Tags=[{Key=Name,Value=altschool-project-rtb-priv}]')
RTB_PRIV_ID=$(echo $RTB_PRIV | jq -r .RouteTable.RouteTableId)
echo $RTB_PRIV | jq -r
echo 'rtb-priv-id = ' $RTB_PRIV_ID
echo "done..."
echo "=================="
echo

echo "export RTB_PRIV_ID=$RTB_PRIV_ID" >>vars.sh

echo "STEP 11.2..."
echo
echo "Creating private subnet route in route table for VPC..."
RT_STATE1=$(aws ec2 create-route --route-table-id $RTB_PRIV_ID --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NAT_ID)
echo 'rt-state1 =o> '
echo $RT_STATE1 | jq -r
echo "done..."
echo "=================="
echo

## Check route has been created and is active
echo "STEP 11.3..."
echo
echo "describing route in route table for private subnet in VPC..."
describe_RTB_PRIV=$(aws ec2 describe-route-tables --route-table-id $RTB_PRIV_ID)
echo 'rtb-state =v'
echo $describe_RTB_PRIV | jq -r
echo "done..."
echo "=================="
echo

## Associate private subnet with custom route table to make it access the internet via NAT gateway
echo "STEP 11.4..."
echo
echo "Associate private subnet with custom route table to make it access the internet via NAT gateway..."
RTB_PRIV_ASSOC=$(aws ec2 associate-route-table --subnet-id $SUBNET2_ID --route-table-id $RTB_PRIV_ID)
RTB_PRIV_ASSOC_ID=$(echo $RTB_PRIV_ASSOC | jq -r .AssociationId)
echo $RTB_PRIV_ASSOC | jq -r
echo 'rtb-priv-assoc-id = ' $RTB_PRIV_ASSOC_ID
echo "done..."
echo "=================="
echo

echo "export RTB_PRIV_ASSOC_ID=$RTB_PRIV_ASSOC_ID" >>vars.sh

##### LAUNCH INSTANCE INTO SUBNET FOR TESTING #####

## Create a key pair and output to server-key.pem
echo "STEP 12..."

rm -rf ./$KEY_NAME.pem
echo "Create a key pair and output to $KEY_NAME.pem"

aws ec2 create-key-pair \
  --tag-specification 'ResourceType=key-pair,Tags=[{Key=Name,Value=altschool-project-key-pair}]' \
  --key-name $KEY_NAME \
  --query 'KeyMaterial' --output text >$KEY_NAME.pem

KEY_PAIR=$(
  aws ec2 describe-key-pairs --key-name $KEY_NAME
)

KEY_PAIR_ID=$(echo $KEY_PAIR | jq -r .KeyPairs[0].KeyPairId)
echo $KEY_PAIR | jq -r
echo 'key-pair-name = ' $KEY_NAME
echo 'key-pair-id = ' $KEY_PAIR_ID
echo "done..."
echo "=================="
echo

echo "export KEY_NAME=$KEY_NAME" >>vars.sh
echo "export KEY_PAIR_ID=$KEY_PAIR_ID" >> vars.sh

## Linux / Mac only - modify permissions
echo "STEP 13..."

echo "Updating key permissions"
ls -la $KEY_NAME.pem
echo "updating..."
chmod 400 $KEY_NAME.pem
ls -la $KEY_NAME.pem
echo "done..."
echo "=================="
echo

## Create security group with rule to allow SSH
echo "STEP 14..."

echo "Create security group with rule to allow SSH to bastion..."
SG_SSH=$(
  aws ec2 create-security-group \
    --group-name SSHAccess \
    --description "Security group for SSH access" \
    --vpc-id $VPC_ID \
    --tag-specification 'ResourceType=security-group,Tags=[{Key=Name,Value=altschool-project-sg-ssh}]'
)
SG_SSH_ID=$(echo $SG_SSH | jq -r .GroupId)
echo $SG_SSH | jq -r
echo 'sg-ssh-id = ' $SG_SSH_ID
echo "done..."
echo "=================="
echo

echo "export SG_SSH_ID=$SG_SSH_ID" >>vars.sh

## Define security group rule to allow SSH
echo "STEP 15..."

echo "Define security group rule to allow SSH to bastion..."
SG_AUTH=$(
  aws ec2 authorize-security-group-ingress \
    --group-id $SG_SSH_ID \
    --protocol tcp --port 22 \
    --cidr 0.0.0.0/0 \
    --tag-specification 'ResourceType=security-group-rule,Tags=[{Key=Name,Value=altschool-project-sgr-ssh}]'
)

echo $SG_AUTH | jq -r
SGR_SSH_RULE_ID=$(echo $SG_AUTH | jq -r .SecurityGroupRules[0].SecurityGroupRuleId)
echo 'sgr-ssh-rule-id = ' $SGR_SSH_RULE_ID
echo "done..."
echo "=================="
echo

echo "export SGR_SSH_RULE_ID=$SGR_SSH_RULE_ID" >>vars.sh

## Create security group with rule to allow SSH, HTTP, HTTPS only within VPC
echo "STEP 16..."

echo "Create security group with rule to allow SSH only within VPC..."
SG_VPC=$(
  aws ec2 create-security-group \
    --group-name VPC-SSHAccess \
    --description "Security group for SSH, HTTP, HTTPS access in VPC" \
    --vpc-id $VPC_ID \
    --tag-specification 'ResourceType=security-group,Tags=[{Key=Name,Value=altschool-project-sg-ssh-vpc}]'
)
SG_VPC_ID=$(echo $SG_VPC | jq -r .GroupId)
echo $SG_VPC | jq -r
echo 'sg-vpc-id = ' $SG_VPC_ID
echo "done..."
echo "=================="
echo

echo "export SG_VPC_ID=$SG_VPC_ID" >>vars.sh

## Define security group rule to allow SSH, HTTP and HTTPS
echo "STEP 17..."

echo "Define security group rule to allow SSH..."
SG_AUTH_SSH_VPC=$(
  aws ec2 authorize-security-group-ingress \
    --group-id $SG_VPC_ID \
    --protocol tcp --port 22 \
    --cidr $VPC_CIDR \
    --tag-specification 'ResourceType=security-group-rule,Tags=[{Key=Name,Value=altschool-project-sgr-ssh-vpc}]'
)
echo
echo "Define security group rule to allow HTTP..."
SG_AUTH_HTTP_VPC=$(
  aws ec2 authorize-security-group-ingress \
    --group-id $SG_VPC_ID \
    --port 80 \
    --cidr $VPC_CIDR \
    --tag-specification 'ResourceType=security-group-rule,Tags=[{Key=Name,Value=altschool-project-sgr-http-vpc}]'
)
echo
echo "Define security group rule to allow HTTPS..."
SG_AUTH_HTTPS_VPC=$(
  aws ec2 authorize-security-group-ingress \
    --group-id $SG_VPC_ID \
    --port 443 \
    --cidr $VPC_CIDR \
    --tag-specification 'ResourceType=security-group-rule,Tags=[{Key=Name,Value=altschool-project-sgr-https-vpc}]'
)
echo SSH Rule
echo $SG_AUTH_SSH_VPC | jq -r
echo HTTP Rule
echo $SG_AUTH_HTTP_VPC | jq -r
echo HTTPS Rule
echo $SG_AUTH_HTTPS_VPC | jq -r
SGR_SSH_VPC_RULE_ID=$(echo $SG_AUTH_SSH_VPC | jq -r .SecurityGroupRules[0].SecurityGroupRuleId)
SGR_HTTP_VPC_RULE_ID=$(echo $SG_AUTH_HTTP_VPC | jq -r .SecurityGroupRules[1].SecurityGroupRuleId)
SGR_HTTPS_VPC_RULE_ID=$(echo $SG_AUTH_HTTPS_VPC | jq -r .SecurityGroupRules[2].SecurityGroupRuleId)
echo 'sgr-ssh-vpc-rule-id = ' $SGR_SSH_VPC_RULE_ID
echo 'sgr-http-vpc-rule-id = ' $SGR_HTTP_VPC_RULE_ID
echo 'sgr-https-vpc-rule-id = ' $SGR_HTTPS_VPC_RULE_ID
echo "done..."
echo "=================="
echo

echo "export SGR_SSH_VPC_RULE_ID=$SGR_SSH_VPC_RULE_ID" >>vars.sh
echo "export SGR_HTTP_VPC_RULE_ID=$SGR_HTTP_VPC_RULE_ID" >>vars.sh
echo "export SGR_HTTPS_VPC_RULE_ID=$SGR_HTTPS_VPC_RULE_ID" >>vars.sh

## Create security group with rule to allow HTTP
echo "STEP 18..."

echo "Create security group with rule to allow HTTP..."
SG_HTTP=$(
  aws ec2 create-security-group \
    --group-name HTTPAccess \
    --description "Security group for HTTP access" \
    --vpc-id $VPC_ID \
    --tag-specification 'ResourceType=security-group,Tags=[{Key=Name,Value=altschool-project-sg-http}]'
)
SG_HTTP_ID=$(echo $SG_HTTP | jq -r .GroupId)
echo $SG_HTTP | jq -r
echo 'sg-http-id = ' $SG_HTTP_ID
echo "done..."
echo "=================="
echo

echo "export SG_HTTP_ID=$SG_HTTP_ID" >>vars.sh

## Define security group rule to allow SSH
echo "STEP 19..."

echo "Create security group with rule to allow SSH..."
SGR_HTTP_RULE_AUTH=$(
  aws ec2 authorize-security-group-ingress \
    --group-id $SG_HTTP_ID --protocol tcp \
    --port 80 --cidr 0.0.0.0/0 \
    --tag-specification 'ResourceType=security-group-rule,Tags=[{Key=Name,Value=altschool-project-sgr-http}]'
)

echo $SGR_HTTP_RULE_AUTH | jq -r
SGR_HTTP_RULE_ID=$(echo $SGR_HTTP_RULE_AUTH | jq -r .SecurityGroupRules[0].SecurityGroupRuleId)
echo 'sgr-http-rule-id = ' $SGR_HTTP_RULE_ID
echo "done..."
echo "=================="
echo

echo "export SGR_HTTP_RULE_ID=$SGR_HTTP_RULE_ID" >>vars.sh

## Create one bastion ec2 instance in the public subnet
## AMI => ubuntu 22.04 LTS 64-bit (x86)
echo "STEP 20..."

echo "Creating one bastion ec2 instance in the public subnet..."
BASTION=$(
  aws ec2 run-instances \
    --image-id ami-0574da719dca65348 \
    --count 1 \
    --instance-type t2.micro \
    --key-name $KEY_NAME \
    --security-group-ids $SG_SSH_ID \
    --subnet-id $SUBNET1_ID \
    --tag-specification 'ResourceType=instance,Tags=[{Key=Name,Value=altschool-project-bastion}]'
)

BASTION_ID=$(echo $BASTION | jq -r .Instances[0].InstanceId)
BASTION_PUBLIC_IP=$(echo $BASTION | jq -r .Instances[0].PublicIpAddress)
BASTION_PRIVATE_IP=$(echo $BASTION | jq -r .Instances[0].PrivateIpAddress)
echo $BASTION | jq -r
echo 'bastion-id = ' $BASTION_ID
echo 'bastion-pub-ip = ' $BASTION_PUBLIC_IP
echo 'bastion-priv-ip = ' $BASTION_PRIVATE_IP
echo "done..."
echo "=================="
echo

echo "export BASTION_ID=$BASTION_ID" >>vars.sh
echo "export BASTION_PUBLIC_IP=$BASTION_PUBLIC_IP" >>vars.sh
echo "export BASTION_PRIVATE_IP=$BASTION_PRIVATE_IP" >>vars.sh

## Create two ec2 instances in the private subnet
## AMI => ubuntu 22.04 LTS 64-bit (x86)
echo "STEP 21..."

echo "Creating two replica ec2 instances in the private subnet..."
REPLICA=$(
  aws ec2 run-instances \
    --image-id ami-0574da719dca65348 \
    --count 2 \
    --instance-type t2.micro \
    --security-group-ids $SG_VPC_ID \
    --key-name $KEY_NAME \
    --subnet-id $SUBNET2_ID \
    --tag-specification 'ResourceType=instance,Tags=[{Key=Name,Value=altschool-project-priv-replica}]'
)
echo
echo $REPLICA | jq -r
echo
REPLICA1_ID=$(echo $REPLICA | jq -r .Instances[0].InstanceId)
REPLICA1_PRIVATE_IP=$(echo $REPLICA | jq -r .Instances[0].PrivateIpAddress)

REPLICA2_ID=$(echo $REPLICA | jq -r .Instances[1].InstanceId)
REPLICA2_PRIVATE_IP=$(echo $REPLICA | jq -r .Instances[1].PrivateIpAddress)

echo $REPLICA1 | jq -r
echo 'replica1-id = ' $REPLICA1_ID
echo 'replica1-priv-ip = ' $REPLICA1_PRIVATE_IP
echo
echo ">>==============<<"
echo
echo $REPLICA2 | jq -r
echo 'replica2-id = ' $REPLICA2_ID
echo 'replica2-priv-ip = ' $REPLICA2_PRIVATE_IP
echo "done..."
echo "=================="
echo

echo "export REPLICA1_ID=$REPLICA1_ID" >>vars.sh
echo "export REPLICA2_ID=$REPLICA2_ID" >>vars.sh
echo "export REPLICA1_PRIVATE_IP=$REPLICA1_PRIVATE_IP" >>vars.sh
echo "export REPLICA2_PRIVATE_IP=$REPLICA2_PRIVATE_IP" >>vars.sh

sleep 30
## CREATE LOAD BALANCER

# Create target groups
echo "STEP 22..."

echo "Create target groups..."
TARGETS=$(
  aws elbv2 create-target-group \
    --name altschool-targets \
    --protocol HTTP \
    --port 80 \
    --target-type instance \
    --vpc-id $VPC_ID
)

sleep 30

TARGET1_ARN=$(echo $TARGETS | jq -r .TargetGroups[0].TargetGroupArn)
echo $TARGETS | jq -r
echo 'target-grp-arn = ' $TARGET1_ARN
echo "done..."
echo "=================="
echo

echo "export TARGET1_ARN=$TARGET1_ARN" >>vars.sh

sleep 1m

# register targets
echo "STEP 23..."

echo "Register targets..."
REG_TARGETS=$(
  aws elbv2 register-targets \
    --target-group-arn $TARGET1_ARN \
    --targets Id=$REPLICA1_ID Id=$REPLICA2_ID
)
echo $REG_TARGETS | jq -r
echo "done..."
echo "=================="
echo

# Create load balancer
echo "STEP 24..."

echo "Create load balancer..."
LB=$(
  aws elbv2 create-load-balancer \
    --name altschool-load-balancer \
    --subnets $SUBNET1_ID $SUBNET3_ID \
    --security-groups $SG_HTTP_ID
)

LB_ARN=$(echo $LB | jq -r .LoadBalancers[0].LoadBalancerArn)
LB_DNSName=$(echo $LB | jq -r .LoadBalancers[0].DNSName)
echo $LB | jq -r
echo 'lb-arn = ' $LB_ARN
echo 'lb-dns = ' $LB_DNSName
echo "done..."
echo "=================="
echo

echo "export LB_ARN=$LB_ARN" >>vars.sh
echo "export LB_DNSName=$LB_DNSName" >>vars.sh

# Create listener
echo "STEP 25..."

echo "Create listener..."
LISTENERS=$(
  aws elbv2 create-listener \
    --load-balancer-arn $LB_ARN \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$TARGET1_ARN
)

LISTENERS_ARN=$(echo $LISTENERS | jq -r .Listeners[0].ListenerArn)
echo $LISTENERS | jq -r
echo 'listeners-arn = ' $LISTENERS_ARN
echo "done..."
echo "=================="
echo

echo "export LISTENERS_ARN=$LISTENERS_ARN" >>vars.sh

# Describe target
echo "STEP 26..."

echo "Describe target..."
describe_target=$(
  aws elbv2 describe-target-health \
    --target-group-arn $TARGET1_ARN
)

echo 'describe_target ==o> '
echo $describe_target | jq -r
echo "done..."
echo "=================="
echo

## Get public IP of bastion
echo "STEP 27..."

echo "Describe bastion..."
bastion=$(
  aws ec2 describe-instances \
    --instance-ids $BASTION_ID
)

echo 'describe_bastion ==o> '
echo $bastion | jq -r
BASTION_PUBLIC_IP=$(echo $bastion | jq -r .Reservations[0].Instances[0].PublicIpAddress)
echo "BASTION_PUBLIC_IP = $BASTION_PUBLIC_IP"
echo "done..."
echo "=================="
echo
echo "export BASTION_PUBLIC_IP=$BASTION_PUBLIC_IP" >>vars.sh

## Creating hosts file for ansible configuration
echo "STEP 28..."

echo "Creating hosts file"
rm -rf ./hosts
touch hosts

echo '[bastion]' >>hosts
echo $BASTION_PUBLIC_IP ansible_user=ubuntu >>hosts
echo
echo '[replica]' >>hosts
echo $REPLICA1_PRIVATE_IP ansible_user=ubuntu >>hosts
echo $REPLICA2_PRIVATE_IP ansible_user=ubuntu >>hosts

cp hosts ansible/

echo 'done...'
echo
echo
echo 'WHAT NEXT?'
echo
echo
echo '1. VERIFY THAT ALL SERVICES ARE RUNNING ON THE AWS CONSOLE'
echo '2. NAVIGATE INTO "ansible/" DIRECTORY'
echo "3. RUN THE PLAYBOOK TO CONFIGURE YOUR BASTION
echo "   ansible-playbook bastion-playbook.yml --private-key ../$KEY_NAME.pem -i hosts"
echo '4. AFTER THAT RUN THE ANSIBLE PLAYBOOK TO CONFIGURE THE BASTION'
echo '5. OBTAIN THE PUBLIC IP OF THE BASTION FROM THE "hosts" file or from the "vars.sh" file'
echo '6. SSH INTO THE BASTION USING THE GENERATED "server-key.pem" FILE '
echo "   ssh -i $KEY_NAME.pem ubuntu@$BASTION_PUBLIC_IP"
echo '7. NAVIGATE TO THE "ansible" DIRECTORY ON THE UBUNTU USER DIRECTORY'
echo '   cd ansible/'
echo '8. RUN ANOTHER PLAYBOOK TO CONFIGURE THE REPLICAS'
echo "   ansible-playbook replica-playbook.yml --private-key ../$KEY_NAME.pem -i hosts"
