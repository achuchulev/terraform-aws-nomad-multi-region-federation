// Creates security group with all ports Nomad needs

resource "aws_security_group" "allow_nomad_traffic_sg" {
  name        = "allow_nomad_traffic_sg"
  description = "Allow traffic needed for Nomad"
  vpc_id      = var.aws_vpc_id

  // ssh
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // nomad
  ingress {
    from_port   = "4646"
    to_port     = "4648"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "4648"
    to_port     = "4648"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_nomad_traffic"
  }
}

