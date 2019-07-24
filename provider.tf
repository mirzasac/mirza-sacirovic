provider "aws" {
  profile = "default"
  # access_key = "${var.access_key}"
  # secret_key = "${var.secret_key}"
  region = "${var.region}"
}
provider "github" {
  token = "${data.aws_ssm_parameter.mirzasa-github-token.value}"
  organization = "mirzasalovanovic"
}