# How to create a load balancer that sits in front of a VPC and routes traffic to available servers in it's private subnet.

<img src='./Load balancer architecture altschool project.drawio.png' alt='Network Architecture'/>

<!-- ![Load balancer architecture altschool project drawio](https://user-images.githubusercontent.com/65220956/211167637-65c2945e-74fe-4556-9fdc-7813bd40ddae.png) -->

## Requirements:
- An AWS account
- A linux system (preferrably ubuntu)
## Packages required
- AWS CLI (properly configured with administrative access)
- jq
- ansible (configured to run the `ansible-playbook` command)

## Steps
- Create a VPC with 3 subnets. 
- Create 3 servers using the VPC. 1 should be public while 2 are private.
- Configure the 2 private servers by jumping in through the public server with ansible.
- A load balancer should target the 2 private servers.

## Automation
- Run [provision.sh](./provision.sh)
```
cd path/to/this/directory/on/your/machine
./provision.sh
```

- It will spin up all required instances and write a hosts file to be used for configuration with ansible

- It will also save the identifiers of provisioned resources so they can be deleted using `destroy-services.sh`

## Configure Bastion
command: 
```bash
cd path/to/this/directory/on/your/machine
cd ansible
ansible-playbook bastion-playbook.yml --private-key ../${KEY_NAME}.pem -i hosts
```
> Make sure to answer yes when prompted to add your keys. Further instructions are present after you've successfully spun up your resources.

After your bastion is configured, you'll have to ssh into it an configure your replicas
```
cd path/to/this/directory/on/your/machine
cd ansible
ssh -i ../${KEY_NAME}.pem ubuntu@${BASTION_PUBLIC_IP}
```

## Configure Replicas
command: 
```bash
cd ansible
ansible-playbook replica-playbook.yml --private-key ../${KEY_NAME}.pem -i hosts
```
> Make sure to answer yes when prompted to add your keys.

## Deletion of resources

- Run the following commands
```
cd path/to/this/directory/on/your/machine
. vars.sh
./destroy-services.sh
```
> If any resources complain about still being in use just wait a bit and run the `destroy-services.sh` script again

