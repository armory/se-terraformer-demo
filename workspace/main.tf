terraform {
  backend "s3" {
    bucket = "armory-tender-terraformer-backend"
    key    = "tfstate"
    region = "us-west-2"
    profile= "terraform"
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "terraform"
  version = "~> 2.51"
}

variable "environment_name" {
  default = "test"
}

resource "aws_s3_bucket" "b" {
  bucket = "terraformer-${var.environment_name}"
  acl    = "public-read"

  tags = {
    Name = "Bucket for ${var.environment_name}"
  }
}

output "test_output" {
    value = "${aws_s3_bucket.b.arn}"
}