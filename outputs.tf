## Outputs DC1
output "dc1-nomad_server_public_ip" {
  value = ["${module.dc1-nomad_server.instance_public_ip}"]
}

output "dc1-nomad_server_private_ip" {
  value = ["${module.dc1-nomad_server.instance_private_ip}"]
}

output "dc1-nomad_server_public_dns" {
  value = ["${module.dc1-nomad_server.instance_public_dns}"]
}

output "dc1-nomad_server_tags" {
  value = ["${module.dc1-nomad_server.instance_tags}"]
}

output "dc1-nomad_client_public_ip" {
  value = ["${module.dc1-nomad_client.instance_public_ip}"]
}

output "dc1-nomad_client_private_ip" {
  value = ["${module.dc1-nomad_client.instance_private_ip}"]
}

output "dc1-nomad_client_public_dns" {
  value = ["${module.dc1-nomad_client.instance_public_dns}"]
}

output "dc1-nomad_client_tags" {
  value = ["${module.dc1-nomad_client.instance_tags}"]
}

## Outputs DC2

output "dc2-nomad_server_public_ip" {
  value = ["${module.dc2-nomad_server.instance_public_ip}"]
}

output "dc2-nomad_server_private_ip" {
  value = ["${module.dc2-nomad_server.private_ips}"]
}

output "dc2-nomad_server_public_dns" {
  value = ["${module.dc2-nomad_server.instance_public_dns}"]
}

output "dc2-nomad_server_tags" {
  value = ["${module.dc2-nomad_server.instance_tags}"]
}

output "dc2-nomad_client_public_ip" {
  value = ["${module.dc2-nomad_client.instance_public_ip}"]
}

output "dc2-nomad_client_private_ip" {
  value = ["${module.dc2-nomad_client.instance_private_ip}"]
}

output "dc2-nomad_client_public_dns" {
  value = ["${module.dc2-nomad_client.instance_public_dns}"]
}

output "dc2-nomad_client_tags" {
  value = ["${module.dc2-nomad_client.instance_tags}"]
}

## Output frontend

output "frontend_server_public_ip" {
  value = "${module.nomad_frontend.public_ip}"
}
