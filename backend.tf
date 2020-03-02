terraform {
  backend "s3" {
    bucket = "armory-tender-terraformer-backend"
    key    = "tfstate"
    region = "us-west-2"
    profile= "terraform"
  }
}

