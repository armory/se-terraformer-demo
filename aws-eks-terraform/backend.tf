terraform {
  backend "s3" {
    bucket = "armory-chad-bucket"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
