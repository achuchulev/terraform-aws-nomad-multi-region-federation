# Run prod Nomad cluster on AWS with terraform in two different AWS & Nomad regions. A kitchen test is included

## High Level Overview

<img src="diagrams/nginx-reverse-proxy-nomad-multi-region-federation.png" />

## Prerequisites

- git
- terraform (>= 0.12)
- own or control registered domain name for the certificate 
- have a DNS record that associates your domain name and your server’s public IP address
- Cloudflare subscription as it is used to manage DNS records automatically
- AWS subscription
- ssh key
- Use pre-built nomad server,client and frontend AWS AMIs on particullar region or bake your own using [Packer](https://www.packer.io)

## How to run

- Get the repo

```
git clone https://github.com/achuchulev/terraform-aws-nomad-multi-region-federation.git
cd terraform-aws-nomad-multi-region-federation
```

- Create `terraform.tfvars` file

```
# AWS vars
access_key = "your_aws_access_key"
secret_key = "your_aws_secret_key"
ami = "ami-0e431df20c101e6b7" # Ubuntu Xenial Nomad CLIENT AMI # dc1 us-east-2
instance_type = "ec2-instance-instance-type"
public_key = "your_public_ssh_key"
region = "aws-region"
availability_zone = "aws-availability-zone"
subnet_id = "subnet_id"
vpc_security_group_ids = ["security-group/s-id/s"]

# Cloudflare vars
cloudflare_email = "you@email.com"
cloudflare_token = "your-cloudflare-token"
cloudflare_zone = "your.domain" # example: nomadlab.com
subdomain_name = "subdomain_name" # example: lab

# Nomad vars
servers_count = "number-of-nomad-server" # defaults to 3
clients_count = "number-of-nomad-clients" # defaults to 3
instance_role = "client" # used by client module
datacenter = "some-nomad-dc" # define the name of 2nd DC
```


```
Note: Inbound traffic on following ports must be allowed:
      TCP 80 (http)
      TCP 443 (https)
      TCP 4646-4648 (Nomad)
      UDP 4648 (Nomad)
      

      Following immutable infrastructure concept the following AMIs are used in each AWS region:
      us-east-1
            Nomad client:    ami-02ffa51d963317aaf ( Ubuntu Xenial with nomad )
            Nomad server:    ami-0ac8c1373dae0f3e5 ( Ubuntu Xenial with nomad )
      
      us-east-2
            Nomad client:    ami-0e431df20c101e6b7 ( Ubuntu Xenial with nomad )
            Nomad server:    ami-0e2aa4ea219d7657e ( Ubuntu Xenial with nomad )
            Frontend server: ami-0352bc96e72c69d2d ( Ubuntu Xenial with nginx )
```

- Initialize terraform

```
terraform init
```

- Deploy nginx and nomad instances

```
terraform plan
terraform apply
```

- `Terraform apply` will:
  - create new instances on AWS for server/client/frontend
  - copy nomad and nginx configuration files
  - install nomad
  - install cfssl (Cloudflare's PKI and TLS toolkit)
  - generate the selfsigned certificates for Nomad cluster 
  - install nginx
  - configure nginx reverse proxy
  - install certbot
  - automatically enable HTTPS on website with EFF's Certbot, deploying Let's Encrypt certificate
  - check for certificate expiration and automatically renew Let’s Encrypt certificate
  - start nomad server and client
  
## Access Nomad

#### via CLI

for example:

```
$ nomad node status
$ nomad server members
```

```
Note

Nomad CLI defaults to communicating via HTTP instead of HTTPS. As Nomad CLI also searches 
environment variables for default values, the process can be simplified exporting environment 
variables like shown below which is done by the provisioning script:

$ export NOMAD_ADDR=https://your.dns.name
```

#### via WEB UI console

Open web browser, access nomad web console using your instance dns name as URL and verify that 
connection is secured and SSL certificate is valid  

## Run nomad job

#### via UI

- go to `jobs`
- click on `Run job`
- author a job in HCL/JSON format or paste the sample nomad job [nomad_jobs/nginx.hcl](https://github.com/achuchulev/terraform-aws-nomad-1dc-1region/blob/master/nomad_jobs/nginx.hcl) that run nginx on docker
- run `Plan`
- review `Job Plan` and `Run` it

#### via CLI

```
$ nomad job run [options] <job file>
```

## Run kitchen test using kitchen-terraform plugin to verify that expected resources are being deployed   

### on Mac

#### Prerequisites

##### Install rbenv to use ruby version 2.3.1

```
brew install rbenv
rbenv install 2.3.1
rbenv local 2.3.1
rbenv versions
```

##### Add the following lines to your ~/.bash_profile:

```
eval "$(rbenv init -)"
true
export PATH="$HOME/.rbenv/bin:$PATH"
```

##### Reload profile: 

`source ~/.bash_profile`

##### Install bundler

```
gem install bundler
bundle install
```

#### Run the test: 

```
bundle exec kitchen list
bundle exec kitchen converge
bundle exec kitchen verify
bundle exec kitchen destroy
```

### on Linux

#### Prerequisites

```
gem install test-kitchen
gem install kitchen-inspec
gem install kitchen-vagrant
```

#### Run kitchen test 

```
kitchen list
kitchen converge
kitchen verify
kitchen destroy
```

### Sample output

```
Target:  local://

  Command: `terraform state list`
     ✔  stdout should include "module.dc1-nomad_server.aws_instance.new_instance"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.dc1-nomad_client.aws_instance.new_instance"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.dc2-nomad_server.aws_instance.new_instance"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.dc2-nomad_client.aws_instance.new_instance"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.nomad_frontend.aws_instance.nginx_instance"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.nomad_frontend.cloudflare_record.nomad_frontend"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.nomad_frontend.null_resource.certbot"
     ✔  stderr should include ""
     ✔  exit_status should eq 0

Test Summary: 21 successful, 0 failures, 0 skipped
```
