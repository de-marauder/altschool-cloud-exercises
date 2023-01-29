variable "region" {
  type = string
  default = "us-east-1"
}
variable "vpc_cidr" {
  type    = string
  default = "120.0.0.0/16"
}
variable "igw_name_tag" {
  type    = string
  default = "altschool-igw"
}
variable "rtb_name_tag" {
  type    = string
  default = "altschool-rtb-igw"
}

variable "subnet_cidr" {
  type = map(any)
}
variable "subnet_name_tag" {
  type    = string
  default = "altschool-pub-subnet"

}
variable "instance_tag_name" {
  type    = string
  default = "altchool-replica"

}

variable "az" {
  type = map(any)
}

variable "ubuntu_ami" {
  type = string
}

variable "instance_count" {
  type = number
  default = 2
}

variable "keypair_filename" {
  type    = string
  default = "altschool-keypair-tf"

}

variable "route53_zone_dns" {
  type    = string
  default = "example.com"

}
variable "subdomain_host" {
  type    = string
  default = "app"

}

