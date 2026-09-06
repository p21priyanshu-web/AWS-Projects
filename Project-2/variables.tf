variable "tags" {
  type = map(string)

  default = {
    Environment = "prod"
    Application = "acme-commerce-web"
    Company     = "Acme Commerce Pvt. Ltd."
  }
}
variable "company" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

variable "public_subnet" {
  type = list(string)
}
variable "private_subnet" {
  type = list(string)
}
variable "project_name" {
  type = string
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
# variable "ami_id" {
#   type = string
# }
variable "key_name" {
  type = string
}