output "public_ip" {
  value = aws_instance.nginx_instance.public_ip
}

output "public_dns" {
  value = aws_instance.nginx_instance.public_dns
}

output "tags" {
  value = aws_instance.nginx_instance.tags
}

