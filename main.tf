terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = "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"
  owner = "SychP"
}

resource "github_repository_collaborator" "collaborator" {
  repository = "SMG-MD"
  username   = "Vova-H"
  permission = "admin"
}

resource "github_repository_file" "codeowner" {
  repository          = "SMG-MD"
  branch              = "main"
  file                = ".github/CODEOWNERS"
  content             = <<-EOT

* @SychP
  EOT
  overwrite_on_create = true
}

resource "github_repository_file" "pull_request" {
  repository          = "SMG-MD"
  file                = ".github/pull_request_template.md"
  content             = <<-EOT

- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
  EOT
  overwrite_on_create = true
}

resource "github_repository_deploy_key" "DEPLOY_KEY" {
  title      = "DEPLOY_KEY"
  repository = "SMG-MD"
  key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCMnThdjeUpmxFyergCeh7E3k5Q1JhQGG1zgo3FA73COQE8jaDNQT5d6I+Un16hZKKsDENQj564FcMwB4iEfLJ3IjRfjeRtVU8ckwD85cD0BT8j72F4sVNj+B2AFKWFHtWGGWmAQjGmFJWLqe91xOG/gJg4sYZ5Y93d0BduIxcpOji7j5kl9MzF9hdicbkuIWewpsyKkS/6CLBinvRr/wEVcMvDwGg1pyBO6pvMJEJCYGyBCcgNURvB0IgoAhfvxQIVsQHXUBfY8m52tSTBclhg1vtCGpmyErRSBBq0JK75vOoGCJVwOou3nVBSegQnfpcNrZ1xBv6njGoHKwBQmSkJ"
}

resource "github_actions_secret" "PAT" {
  repository      = "SMG-MD"
  secret_name     = "PAT"
  plaintext_value = "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"
}

resource "github_branch" "develop" {
  repository = "SMG-MD"
  branch     = "develop"
}

resource "github_branch_default" "default" {
  repository = "SMG-MD"
  branch     = github_branch.develop.branch
}

resource "github_branch_protection" "develop" {
  repository_id = "SMG-MD"
  pattern       = "develop"

  required_pull_request_reviews {
    required_approving_review_count = 2
  }
}

resource "github_branch_protection" "main" {
  repository_id = "SMG-MD"
  pattern       = "main"

  required_pull_request_reviews {
    require_code_owner_reviews      = true
    required_approving_review_count = 0
  }
}
