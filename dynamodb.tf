resource "aws_dynamodb_table" "mirzasa-terraform" {
  name = "mirzasa-terraform"
  hash_key = "LockID"
  read_capacity = 15
  write_capacity = 15
  attribute {
      name = "LockID"
      type = "S"
  }
}