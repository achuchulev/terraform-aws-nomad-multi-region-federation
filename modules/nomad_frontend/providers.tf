# Configure the AWS provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# Configure the Cloudflare provider
provider "cloudflare" {
  email = var.cloudflare_email
  token = var.cloudflare_token
}

