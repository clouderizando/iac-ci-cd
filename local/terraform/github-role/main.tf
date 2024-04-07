provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project    = "GithubIac"
      Terraform  = "true"
      CI         = "false"
      Repository = "https://github.com/clouderizando/iac-ci-cd"
    }
  }
}

resource "aws_iam_openid_connect_provider" "github_actions_oidc" {
    url = "https://token.actions.githubusercontent.com"
    client_id_list = [
        "sts.amazonaws.com",
    ]
    thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_actions_administrator_role" {
    name               = "GitHubActionsAdministratorRole"
    assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Effect   = "Allow"
                Principal = {
                    Federated = aws_iam_openid_connect_provider.github_actions_oidc.arn
                },
                Action   = "sts:AssumeRoleWithWebIdentity"
                Condition = {
                    StringEquals = {
                        "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
                        "token.actions.githubusercontent.com:sub" = "repo:clouderizando/iac-ci-cd:ref:refs/heads/main"
                    }
                }
            },
        ]
    })
    inline_policy {
        name = "AdministratorAccessPolicy"
        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [
                {
                    Effect   = "Allow"
                    Action   = "*"
                    Resource = "*"
                },
            ]
        })
  }
}

resource "aws_iam_role" "github_actions_infra_read_only_role" {
    name               = "GitHubActionsInfraReadOnlyRole"
    assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Effect   = "Allow"
                Principal = {
                    Federated = aws_iam_openid_connect_provider.github_actions_oidc.arn
                },
                Action   = "sts:AssumeRoleWithWebIdentity"
                Condition = {
                    StringEquals = {
                        "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
                    }
                    StringLike   = {
                       "token.actions.githubusercontent.com:sub" = "repo:clouderizando/iac-ci-cd:ref:refs/heads/*"
                    }
                }
            },
        ]
    })
    managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}
