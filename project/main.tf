terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "6.6.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

# What is requrired
variable "github_token" {
  type = string
  sensitive = true
}

# What exists
resource "github_repository" "this_repository" {
  name = "porsgrunn-iac-intro"
  visibility = "public"
}

# What to return
output "repository" {
  value = github_repository.this_repository.html_url
}
