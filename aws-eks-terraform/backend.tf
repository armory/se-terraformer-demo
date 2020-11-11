terraform {
  backend "s3" {
    bucket = "armory-chad-bucket"
    key    = "path/to/my/key"
    region = "us-west-2"
  }
}
