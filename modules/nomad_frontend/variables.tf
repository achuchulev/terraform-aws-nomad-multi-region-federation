variable "access_key" {
}

variable "secret_key" {
}

variable "public_key" {
}

variable "region" {
  default = "us-east-1"
}

variable "availability_zone" {
  default = "us-east-1b"
}

variable "ami" {
  description = "Ubuntu Xenial Frontend Server AMI # dc1 us-east-1"
  default     = "ami-090c16342ee6bb5cc"
}

variable "aws_vpc_id" {
}

variable "instance_type" {
}

variable "subnet_id" {
}

variable "cloudflare_email" {
}

variable "cloudflare_token" {
}

variable "cloudflare_zone" {
}

variable "subdomain_name" {
}

variable "backend_private_ips" {
}

variable "dc" {
  type    = string
  default = "dc1"
}

variable "frontend_region" {
  type = string
}

variable "nomad_region" {
  default = "global"
}

