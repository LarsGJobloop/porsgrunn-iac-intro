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
