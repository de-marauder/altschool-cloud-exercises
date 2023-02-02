# How to provision a loadbalancer and map it to route 53 using terraform

---

## Requirements to run this project
- AWS CLI (configured with proper credentials for terraform)
- Terraform

# How it works
1. Create a VPC
2. Create 3 public subnets in 3 different AZs
3. Create EC2 instances one in each of the public subnets (no of EC2 instances is dependent on number of subnets)
4. Write a hosts file for ansible configuration
5. Create a load balancer in front of the EC2 instances
6. Create a DNS zone and map a custom domain on route 53 to the load balancer
7. Enter the ansible directory and run the following commands one by one.
   ```bash
   cd ./ansible
   ansible -m ping -i host-inventory --private-key key all
   ansible-playbook -i host-inventory setup-apache.yaml --private-key key
   ```
   Make sure to type yes when prompted.
8. Copy the outputted nameservers to your domain provider
9. Check the subdomain created

## Extras
- A remote s3 backend module with serverside encryption

# Commands
1. Initialization
```
terraform init
```

2. Planning
```
terraform plan
```

3. Applying changes and provision infrastructure
```
terraform apply
```

4. Destroy infrastructure
```
terraform destroy
```

---