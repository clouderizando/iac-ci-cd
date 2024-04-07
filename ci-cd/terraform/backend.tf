terraform {
  backend "s3" {
    bucket = "clouderizando-iac-ci-cd"
    key    = "ci-cd/terraform"
    region = "us-east-1"
  }
}
