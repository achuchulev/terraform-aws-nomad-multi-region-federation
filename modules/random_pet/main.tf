# Use terraform random_pet provider to generate a random name  
resource "random_pet" "random_name" {
  length    = "4"
  separator = "-"
}

