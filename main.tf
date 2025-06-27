terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "6.6.0"
    }
  }
}

provider "github" {
  token = "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"
}

# What exists
resource "github_repository" "this_repository" {
  name = "porsgrunn-iac-intro"
  visibility = "private"
}

output "repository" {
  value = github_repository.this_repository.html_url
}
