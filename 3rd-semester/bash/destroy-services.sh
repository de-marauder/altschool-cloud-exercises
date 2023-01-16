##### THIS SCRIPT DELETES ALL RESOURCES PROVISIONED BY THE 'provision.sh' SCRIPT #####

## Run commands in the following order replacing all values as necessary
echo 'deleting instances'
echo "press 'q'"
aws ec2 terminate-instances \
    --instance-ids $BASTION_ID $REPLICA1_ID $REPLICA2_ID
echo "press 'q'"
echo '================================='
echo

echo 'deleting key pair'
aws ec2 delete-key-pair --key-pair-id $KEY_PAIR_ID
echo '================================='
echo

echo 'deleting nat gateway...'
aws ec2 delete-nat-gateway --nat-gateway-id $NAT_ID
sleep 40
echo '================================='
echo 'Nat gateway deleted'
echo '================================='
echo

echo 'deleting ssh security groups'
aws ec2 delete-security-group --group-id $SG_SSH_ID
echo '================================='
echo

echo 'deleting http security groups'
aws ec2 delete-security-group --group-id $SG_HTTP_ID
sleep 15
echo '================================='
echo

echo 'deleting ssh security groups for vpc'
aws ec2 delete-security-group --group-id $SG_VPC_ID
sleep 15
echo '================================='
echo

echo 'deleting subnet 1'
aws ec2 delete-subnet --subnet-id $SUBNET1_ID
echo '================================='
echo

echo 'deleting subnet 2'
aws ec2 delete-subnet --subnet-id $SUBNET2_ID
sleep 15
echo '================================='
echo

echo 'deleting subnet 3'
aws ec2 delete-subnet --subnet-id $SUBNET3_ID
sleep 15
echo '================================='
echo

echo 'deleting route table for internet gateway'
aws ec2 delete-route-table --route-table-id $RTB_ID
echo '================================='
echo

echo 'deleting route table for NAT gateway'
aws ec2 delete-route-table --route-table-id $RTB_PRIV_ID
echo '================================='
echo

echo 'detaching internet-gateway'
aws ec2 detach-internet-gateway \
    --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
sleep 15
echo '================================='
echo

echo 'deleting internet-gateway'
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID
sleep 30
echo '================================='
echo

echo 'deleting VPC'
aws ec2 delete-vpc --vpc-id $VPC_ID
echo '================================='
echo

echo 'releasing elastic IP'
aws ec2 release-address --allocation-id $EIP_ALLOC_ID
echo '================================='
echo

echo 'deleting target groups'
aws elbv2 delete-target-group \
    --target-group-arn $TARGET1_ARN
sleep 30
echo '================================='
echo

echo 'deleting listeners'
aws elbv2 delete-listener \
    --listener-arn $LISTENERS_ARN
sleep 30
echo '================================='
echo

echo 'deleting load balancer'
aws elbv2 delete-load-balancer \
    --load-balancer-arn $LB_ARN
echo '================================='
echo
echo "done"
echo "PLEASE CHECK YOUR CONSOLE TO VERIFY NO SERVICES ARE STILL RUNNING"
echo
