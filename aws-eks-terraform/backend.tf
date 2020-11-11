terraform {
  backend "s3" {
    bucket = "armory-chad-bucket"
    key    = "terraform"
    region = "us-west-2"
  }
}
