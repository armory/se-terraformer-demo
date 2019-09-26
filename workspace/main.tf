terraform {
  backend "s3" {}
}

provider "aws" {
  region  = "us-west-2"
  profile = "terraform"
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