#!/usr/bin/env bash

echo "Configuring nomad ..."

mkdir -p /etc/nomad.d
chmod 700 /etc/nomad.d
touch /etc/nomad.d/nomad.hcl

# Enable Nomad's CLI command autocomplete support. Skip if installed
grep "complete -C /usr/bin/nomad nomad" ~/.bashrc &>/dev/null || nomad -autocomplete-install

cat <<EOF >/etc/nomad.d/nomad.hcl

data_dir  = "/opt/nomad"

region = "$1"

datacenter = "$2"

bind_addr = "0.0.0.0"

server {
  enabled = true
  bootstrap_expect = 3
  authoritative_region = "$3"
  server_join {
    retry_join = ["$4"]
    retry_max = 5
    retry_interval = "15s"
  }

  encrypt = "$5"
}

# Require TLS
tls {
  http = true
  rpc  = true

  ca_file   = "/home/ubuntu/nomad/ssl/nomad-ca.pem"
  cert_file = "/home/ubuntu/nomad/ssl/server.pem"
  key_file  = "/home/ubuntu/nomad/ssl/server-key.pem"

  verify_server_hostname = true
  verify_https_client    = true
}
EOF