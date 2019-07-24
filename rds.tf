# #Security Group
# resource "aws_security_group" "mirzasa-rds-security-group" {
#   name = "mirzasa-rds-psql"
#   description = "mirzasa Security Group for PostgreSQL RDS Instance"
#   vpc_id = "${aws_vpc.mirzasa-vpc.id}"
#   ingress {
#       from_port = 5432
#       to_port = 5432
#       protocol = "tcp"
#       cidr_blocks = [
#           "10.10.10.0/24",
#           "10.10.20.0/24",
#           "10.10.30.0/24",
#           "10.10.40.0/24"
#       ]
#   }
#   egress {
#       from_port = 0
#       to_port = 0
#       protocol = "-1"
#       cidr_blocks = [
#           "0.0.0.0/0"
#       ]
#   }
# }
# #RDS Subnet Group
# resource "aws_db_subnet_group" "mirzasa-rds-subnet-group" {
#   name = "mirzasa-rds-subnet-group"
#   subnet_ids = [
#       "${aws_subnet.private-subnet-1.id}",
#       "${aws_subnet.private-subnet-2.id}"
#   ]
#   description = "mirzasa Subnet Group"
# }
# #RDS PostgreSQL Instance
# resource "aws_db_instance" "mirzasa-psql-rds" {
#   identifier = "mirzasa-rds-instance-${var.env}"
#   engine = "postgres"
#   engine_version = "9.6"
#   port = "5432"
#   instance_class = "${lookup(var.rds-instance-class, var.env)}"
#   db_subnet_group_name = "${aws_db_subnet_group.mirzasa-rds-subnet-group.id}"
#   multi_az = "${lookup(var.rds-multi-az, var.env)}"
#   username = "${var.rds-username}"
#   password = "${var.rds-password}"
#   publicly_accessible = false
#   vpc_security_group_ids = [
#     "${aws_security_group.mirzasa-rds-security-group.id}"
#   ]
#   storage_type = "${lookup(var.rds-storage-type, var.env)}"
#   allocated_storage = "${lookup(var.rds-allocated-storage, var.env)}"
#   name = "mirzasadb"
#   apply_immediately = "${lookup(var.rds-apply-immediately, var.env)}"
#   skip_final_snapshot = "${lookup(var.rds-skip-final-snapshot, var.env)}"

#   tags = {
#       Name = "mirzasa PostgreSQL RDS Instance"
#   }
# }