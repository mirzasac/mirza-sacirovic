# #AWS Key Pair
# resource "aws_key_pair" "ec2-key-pair" {
#   key_name = "mirzasa-key-pair"
#   public_key = "${file(var.ssh-public-key)}"
# }
# #AWS EC2 Instance
# resource "aws_instance" "ec2-instance" {
#   ami = "ami-097ebb39620d8d54b"
#   instance_type = "t2.micro"
#   key_name = "${aws_key_pair.ec2-key-pair.key_name}"
#   subnet_id = "${aws_subnet.public-subnet-1.id}"
#   vpc_security_group_ids = [
#       "${aws_security_group.instance-sg.id}"
#   ]
#   root_block_device {
#       volume_type = "gp2"
#       volume_size = 8
#       delete_on_termination = true
#   }
#   volume_tags = {
#       Name = "mirzasa-ec2-instance-root-volume"
#   }
#   user_data = <<-EOF
#             #!/bin/bash
#             apt-get update
#             curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
#             apt-get install -y nodejs
#             EOF
#   tags = {
#       Name= "mirzasa-ec2-tags"
#   }
# }
# #Ellastic IP Associations
# resource "aws_eip_association" "ec2-association" {
#   instance_id = "${aws_instance.ec2-instance.id}"
#   allocation_id = "${aws_eip.ec2-eip.id}"
# }