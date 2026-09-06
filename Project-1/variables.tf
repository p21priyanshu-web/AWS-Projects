variable "vpc_cidr_block" {
  type = string
}
variable "enable_dns_hostnames" {
  type = bool
}
variable "enable_dns_support" {
  type = bool
}
variable "vpc_name" {
  type = string
}
variable "project_name" {
  type = string
}
variable "public_subnet_1_cidr" {
  type = string

}
variable "public_subnet_2_cidr" {
  type = string
}
variable "public_subnet_az_1" {
  type = string
}
variable "public_subnet_az_2" {
  type = string
}
variable "public_subnet_1_name" {
  type = string

}
variable "public_subnet_2_name" {
  type = string

}
variable "private_subnet_1_cidr" {
  type = string
}
variable "private_subnet_2_cidr" {
  type = string
}
variable "private_subnet_1_name" {
  type = string
}
variable "private_subnet_2_name" {
  type = string
}
variable "igw_name" {
  type = string
}
variable "public_rt_name" {
  type = string
}
variable "private_rt_1_name" {
  type = string
}
variable "eip_1_name" {
  type = string
}
variable "eip_2_name" {
  type = string
}
variable "nat_gw_name_1" {
  type = string
}
variable "nat_gw_name_2" {
  type = string
}
variable "private_rt_2_name" {
  type = string
}
variable "region" {
  type = string
}