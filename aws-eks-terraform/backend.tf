terraform {
  backend "s3" {
    bucket = "armory-tf-bucket"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
