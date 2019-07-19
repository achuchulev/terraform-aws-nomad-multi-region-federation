variable "nomad_instance_count" {
  default = "3"
}

variable "access_key" {}
variable "secret_key" {}

variable "instance_role" {
  description = "Nomad instance type"
  default     = "server"
}

variable "public_key" {}

variable "region" {}

variable "aws_vpc_id" {}

variable "availability_zone" {}

variable "ami" {
  description = "Ubuntu Xenial Nomad Server AMI # dc1 us-east-2"
  default     = "ami-0e2aa4ea219d7657e"
}

variable "instance_type" {}
variable "subnet_id" {}

# variable "vpc_security_group_ids" {
#   type = "list"
# }

variable "role_name" {
  description = "Name for IAM role, defaults to \"nomad-cloud-auto-join-aws\"."
  default     = "nomad-cloud-auto-join-aws"
}

variable "dc" {
  type    = "string"
  default = "dc1"
}

variable "nomad_region" {
  type    = "string"
  default = "global"
}

variable "authoritative_region" {
  type    = "string"
  default = "global"
}

variable "retry_join" {
  description = "Used by Nomad to automatically form a cluster."
  default     = "provider=aws tag_key=nomad-node tag_value=server"
}

variable "secure_gossip" {
  description = "Used by Nomad to enable gossip encryption"
  default     = "null"
}

variable "zone_name" {}

variable "domain_name" {}

variable "sg_id" {}
