resource "null_resource" "generate_self_ca" {
  provisioner "local-exec" {
    # script called with private_ips of nomad backend servers
    command = "${path.root}/scripts/gen_self_ca.sh ${var.nomad_region} ${var.region2_nomad_region}"
  }
}

resource "random_id" "server_gossip" {
  byte_length = 16
}

// Module to create needed security groups for nomad

module "nomad_security_groups_region1" {
  source     = "./modules/security_groups"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
  aws_vpc_id = var.vpc_id
}

module "nomad_security_groups_region2" {
  source     = "./modules/security_groups"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region2
  aws_vpc_id = var.region2_vpc_id
}

# Module that creates Nomad server instances in AWS region A, Nomad region A and Nomad dc1
module "dc1-nomad_server" {
  source = "./modules/nomad_instance"

  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region

  nomad_instance_count = var.servers_count

  aws_vpc_id        = var.vpc_id
  subnet_id         = var.subnet_id
  availability_zone = var.availability_zone
  ami               = var.server_ami
  instance_type     = var.instance_type
  public_key        = var.public_key
  sg_id             = module.nomad_security_groups_region1.security_group_id

  nomad_region         = var.nomad_region
  authoritative_region = var.nomad_region

  domain_name   = var.subdomain_name
  zone_name     = var.cloudflare_zone
  secure_gossip = random_id.server_gossip.b64_std
}

# Module that creates Nomad server instances in AWS region B, Nomad region B and Nomad dc1
module "dc2-nomad_server" {
  source = "./modules/nomad_instance"

  region            = var.region2
  aws_vpc_id        = var.region2_vpc_id
  availability_zone = var.region2_availability_zone
  nomad_region      = var.region2_nomad_region
  ami               = var.region2_server_ami

  #dc                   = "${var.datacenter}"
  authoritative_region = var.nomad_region
  nomad_instance_count = var.servers_count
  access_key           = var.access_key
  secret_key           = var.secret_key
  instance_type        = var.instance_type
  public_key           = var.public_key
  subnet_id            = var.region2_subnet_id
  sg_id                = module.nomad_security_groups_region2.security_group_id

  domain_name   = var.subdomain_name
  zone_name     = var.cloudflare_zone
  secure_gossip = random_id.server_gossip.b64_std
}

# Module that creates Nomad client instances in AWS region A, Nomad region A and Nomad dc1
module "dc1-nomad_client" {
  source = "./modules/nomad_instance"

  region               = var.region
  nomad_region         = var.nomad_region
  aws_vpc_id           = var.vpc_id
  availability_zone    = var.availability_zone
  instance_role        = var.instance_role
  ami                  = var.client_ami
  nomad_instance_count = var.clients_count
  access_key           = var.access_key
  secret_key           = var.secret_key
  instance_type        = var.instance_type
  public_key           = var.public_key
  subnet_id            = var.subnet_id
  sg_id                = module.nomad_security_groups_region1.security_group_id

  domain_name = var.subdomain_name
  zone_name   = var.cloudflare_zone
}

# Module that creates Nomad client instances in AWS region B, Nomad region B and Nomad dc1
module "dc2-nomad_client" {
  source = "./modules/nomad_instance"

  region     = var.region2
  aws_vpc_id = var.region2_vpc_id

  availability_zone = var.region2_availability_zone

  #dc                   = "${var.datacenter}"
  ami                  = var.region2_client_ami
  nomad_region         = var.region2_nomad_region
  instance_role        = var.instance_role
  nomad_instance_count = var.clients_count
  access_key           = var.access_key
  secret_key           = var.secret_key
  instance_type        = var.instance_type
  public_key           = var.public_key
  subnet_id            = var.region2_subnet_id
  sg_id                = module.nomad_security_groups_region2.security_group_id

  domain_name = var.subdomain_name
  zone_name   = var.cloudflare_zone
}

# Module that creates Nomad frontend instance
module "nomad_frontend" {
  source = "./modules/nomad_frontend"

  region            = var.region
  aws_vpc_id        = var.vpc_id
  availability_zone = var.availability_zone
  frontend_region   = var.nomad_region
  access_key        = var.access_key
  secret_key        = var.secret_key
  instance_type     = var.instance_type
  public_key        = var.public_key
  subnet_id         = var.subnet_id

  backend_private_ips = module.dc1-nomad_server.instance_private_ip
  cloudflare_token    = var.cloudflare_token
  cloudflare_zone     = var.cloudflare_zone
  subdomain_name      = var.subdomain_name
  cloudflare_email    = var.cloudflare_email
  nomad_region        = var.nomad_region
}

resource "null_resource" "nomad_federation" {
  depends_on = [
    module.dc1-nomad_server,
    module.dc2-nomad_server,
    module.nomad_frontend,
  ]

  provisioner "remote-exec" {
    # create nomad multi-region federation
    inline = [
      "export NOMAD_ADDR=https://${var.subdomain_name}.${var.cloudflare_zone}",
      "nomad server join '${module.dc2-nomad_server.private_ips[0]}'",
    ]

    connection {
      host        = module.dc1-nomad_server.instance_public_ip[0]
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}

