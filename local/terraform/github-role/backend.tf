terraform {
  backend "s3" {
    bucket = "clouderizando-iac-ci-cd"
    key    = "base/terraform/github-oidc-role"
    region = "us-east-1"
  }
}
