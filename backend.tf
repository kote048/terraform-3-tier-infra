terraform {
  backend "s3" {
    bucket = "netflixproject-kote"
    key    = "state/terraform.tfstate"
    region = "us-west-1"
    workspace_key_prefix  = "env"
  }
}
