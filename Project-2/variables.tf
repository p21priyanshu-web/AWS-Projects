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
  type = map(string)
}
variable "private_subnet" {
  type = map(string)
}
variable "project_name" {
  type = string
}