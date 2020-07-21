terraform {
  backend "remote" {}
}

provider "aws" {
  region  = "us-west-2"
  profile = "terraform"
}

variable "environment_name" {
  default = "tfcloud"
}

variable "acl_setting" {
  default = "public-read"
}

resource "aws_s3_bucket" "b" {
  bucket = "tfe-${var.environment_name}"
  acl    = "${var.acl_setting}"

  tags = {
    Name = "Bucket for ${var.environment_name}"
  }
}

output "test_output" {
    value = "${aws_s3_bucket.b.arn}"
}
