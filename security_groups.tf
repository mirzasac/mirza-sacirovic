# resource "aws_security_group" "mirzasa-sg" {
#     name = "mirzasa-instance-sg"
#     description = "Security Group for mirzasa EC2 Instance"
#     vpc_id = "${aws_vpc.mirzasa-vpc.id}"
#     ingress {
#         from_port = 22
#         to_port = 22
#         protocol = "tcp"
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#     }
#     egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]   
#     }
# }
