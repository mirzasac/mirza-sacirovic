resource "aws_s3_bucket" "mirzasa-terraform" {
  bucket = "mirzasa-terraform"
  region = "${var.region}"
  acl = "private"
  force_destroy = true
  versioning {
      enabled = true
  }
  tags = {
      Name = "mirzasa-terraform"
  }
}