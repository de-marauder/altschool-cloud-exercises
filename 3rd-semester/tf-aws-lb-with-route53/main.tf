module "lb_route53" {
  source = "./lb-route53"

  route53_zone_dns = "de-marauder.me" # (required) Input an already existing domain name
  # subdomain_host = "" # (default = terraform-test) Input prefix for domain eg. 'app', 'dev', 'staging' etc
  vpc_cidr   = "120.0.0.0/16"
  region     = "us-east-1"
  ubuntu_ami = "ami-06878d265978313ca"


  az = {
    "1" = "us-east-1a"
    "2" = "us-east-1b"
    "3" = "us-east-1c"
  }

  subnet_cidr = {
    "1" = "120.0.1.0/24"
    "2" = "120.0.2.0/24"
    "3" = "120.0.3.0/24"
  }
  # subnet_name_tag = "" # Name your subnets
  # igw_name_tag = "" # Name your internet gateway
  key_dir = "ansible/" # Must end with "/"
  keypair_filename = "key" # Name your key pair file
  # instance_count   = 2 # set how many instances to provision (deprecated)
}
