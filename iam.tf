# #IAM Users
# resource "aws_iam_user" "mirzasa" {
#   name = "mirzasa-iac"
# }
# resource "aws_iam_access_key" "mirzasa" {
#   user = "${aws_iam_user.mirzasa.name}"
# }
# resource "aws_iam_policy" "mirzasa" {
#   name = "mirzasa"
#   description = "mirzasa"
#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "mirzasa",
#             "Effect": "Allow",
#             "Action": [
#                 "lambda:GetFunction",
#                 "lambda:ListFunctions"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# EOF
# }
# #User Policy Attachments
# resource "aws_iam_user_policy_attachment" "mirzasa-lambda" {
#   user = "${aws_iam_user.mirzasa.name}"
#   policy_arn = "${aws_iam_policy.mirzasa.arn}"
# }
# resource "aws_iam_user_policy_attachment" "mirzasa-s3" {
#   user = "${aws_iam_user.mirzasa.name}"
#   policy_arn = "${data.aws_iam_policy.s3-full-access.arn}"
# }