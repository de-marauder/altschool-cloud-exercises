# How to create a load balancer that sits in front of a VPC and routes traffic to available servers in it's private subnet using TERRAFORM.

<img src='./Load balancer architecture altschool project.drawio.png' alt='Network Architecture'/>

<!-- ![Load balancer architecture altschool project drawio](https://user-images.githubusercontent.com/65220956/211167637-65c2945e-74fe-4556-9fdc-7813bd40ddae.png) -->

## Requirements:
- An AWS account
- A linux system (preferrably ubuntu)
## Packages required
- terraform
- ansible (configured to run the `ansible-playbook` command)

## Steps
- Create a VPC with 4 subnets. 
- Create 3 servers using the VPC. 1 should be public while 2 are private.
- Configure the 2 private servers with userdata or by jumping in through the public server with ansible.
- A load balancer should target the 2 private servers.

## Automation
- Run terraform commands
```
cd path/to/this/directory/on/your/machine
terraform init
terraform plan
terraform apply
```

- It will spin up all required resources and write a hosts file to be used for configuration with ansible

- It will also save the state of provisioned resources so they can be tracked by terraform.

---
> NOTE: Do not alter configurations outside of terraform. This makes it easier for terraform to track the state of the resources it provisions.
---
## Deletion of resources

- Run the following commands
```
cd path/to/this/directory/on/your/machine
terraform destroy
```
