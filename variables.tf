#Default Region
variable "region" {
  default = "us-east-2"
}
# #SSH Public Key File Path
# variable "ssh-public-key" {
#   default = "~/.ssh/mirzasa.pub"
# }
variable "env" {
  
}
variable "ecr-number-of-images" {
  type = "map"
  default = {
    dev = 5
    qa = 5
    stg = 20
    prod = 20
  }
}
# variable "rds-instance-class" {
#   type = "map"
#   default = {
#     dev = "db.t2.micro"
#     qa = "db.t2.micro"
#     stg = "db.m4.xlarge"
#     prod = "db.m4.xlarge"
#   }
# }
# variable "rds-multi-az" {
#   type = "map"
#   default = {
#     dev = "false"
#     qa = "false"
#     stg = "true"
#     prod = "true"
#   }
# }
# variable "rds-username" {
#   default = "mirzasa"
# }
# variable "rds-password" {
#   default = "$0m3c0mpL3X5a$s"
# }
# variable "rds-storage-type" {
#   type = "map"
#   default = {
#     dev = "gp2"
#     qa = "gp2"
#     stg = "io1"
#     prod = "io1"
#   }
# }
# variable "rds-allocated-storage" {
#   type = "map"
#   default = {
#     dev = 20
#     qa = 20
#     stg = 100
#     prod = 100
#   }
# }
# variable "rds-apply-immediately" {
#   type = "map"
#   default = {
#     dev = "true"
#     qa = "true"
#     stg = "false"
#     prod = "false"
#   }
# }
# variable "rds-skip-final-snapshot" {
#   type = "map"
#   default = {
#     dev = "true"
#     qa = "true"
#     stg = "false"
#     prod = "false"
#   }
# }

#Git Branches
variable "git-branches" {
  type = "map"
  default = {
    dev = "develop"
    qa = "qa"
    stg = "staging"
    prod = "master"
  }
}