output "security_group_id" {
  value = "${aws_security_group.allow_nomad_traffic_sg.id}"
}
