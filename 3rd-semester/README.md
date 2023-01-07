# How to create a load balancer that sits in front of a VPC and routes traffic to available servers in it's private subnet.

## Requirements:
- An AWS account
- A linux system (preferrably ubuntu)
## Packages required
- AWS CLI (properly configured with administrative access)
- jq
- nginx
- ansible

## Steps
- Create a VPC with 2 subnets. 
- Create 3 servers using the VPC. 1 should be public while 2 are private.
- Configure the 2 private servers by jumping in through the public server with ansible.
- A load balancer should target the 2 private servers.

## Automation
- Run provision.sh

- It will spin up all required instances and write a host file to be used for configuration with ansible

- It will also save the identifiers of provisioned resources so they can be deleted using `destroy-services.sh`

## Configure Replicas
command: 
```bash
cd ansible

ansible-playbook replica-playbook.yml --private-key /path/to/keyfile -i hosts
```
> Make sure to answer yes when prompted to add your keys.
