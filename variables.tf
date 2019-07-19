variable "servers_count" {
  description = "The number of servers to provision."
  default     = "3"
}

variable "clients_count" {
  description = "The number of clients to provision."
  default     = "3"
}

variable "datacenter" {
  description = "The name of Nomad datacenter."
  type        = "string"
  default     = "dc1"
}

variable "nomad_region" {
  description = "The name of Nomad region."
  type        = "string"
}

variable "region2_nomad_region" {
  description = "The name of Nomad region."
  type        = "string"
}

variable "authoritative_region" {
  description = "Points the Nomad's authoritative region."
  type        = "string"
  default     = "global"
}

variable "access_key" {}
variable "secret_key" {}

variable "instance_role" {}

variable "public_key" {}

variable "region" {
  default = "us-east-1"
}

variable "region2" {
  default = "us-east-2"
}

variable "availability_zone" {
  default = "us-east-1b"
}

variable "region2_availability_zone" {
  default = "us-east-2c"
}

#variable "ami" {}
variable "instance_type" {}

variable "vpc_id" {}

variable "region2_vpc_id" {}

variable "subnet_id" {}

variable "region2_subnet_id" {}

# variable "vpc_security_group_ids" {
#   type = "list"
# }

# variable "region2_vpc_security_group_ids" {
#   type = "list"
# }

variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "cloudflare_zone" {}
variable "subdomain_name" {}

variable "server_ami" {
  default = "ami-0ac8c1373dae0f3e5"
}

variable "client_ami" {
  default = "ami-02ffa51d963317aaf"
}

variable "frontend_ami" {}

variable "region2_server_ami" {
  default = "ami-0e2aa4ea219d7657e"
}

variable "region2_client_ami" {
  default = "ami-0e431df20c101e6b7"
}
