terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket  = "{your terraform backend bucket}"
    prefix  = "composer"
  }
}