provider "aws" {
  region = "us-west-2"
}

#########################################
# IAM user, login profile and access key
#########################################
module "iam_user" {
  source = "git::https://github.com/armory/se-terraformer-demo.git?ref=v0.1"

  name          = "armory.user.1"
  force_destroy = true

  password_reset_required = false

  # SSH public key
  upload_iam_user_ssh_key = true
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1ErPj8/RY/djPZvDKzOmIgECOTPxGGaKSza1wz/iOkmKTV4rz8xhgcbzrsVmQyRjS/Vos7jShXtdGrs7bhZrSB1ahfGEFuQ3w3j+4bPoMt2QiaarqdG9tPplzKUCZIL7Pmdd6zL9cUI8T98JuakFM7ZSzUQ0TEYvCBwHIVkYukC2nGf0Ey2+sYMnbcuv6IUBnQpFTWpddxAaXBu8aTd1vg6kzKNiKsNE1fBzMenRa1yybaowvfM/ONyZt3YdKI8vIkyY8b8gJhFBInPU4nLjmQbLiGuKtJdtNOjkjkV3gnx7fJtqfNYc5fTivr2j5DgZSUj1mdUFbSKy5L9F5d6nP away@Andrews-MacBook-Pro.local"
}

###################################################################
# IAM user without pgp_key (IAM access secret will be unencrypted)
###################################################################
module "iam_user2" {
  source = "../../modules/iam-user"

  name = "armory.user.2"

  create_iam_user_login_profile = false
  create_iam_access_key         = true
}
