terraform {
    backend "s3" {
        region = "us-east-2"
        bucket = "mirzasa-terraform"
        dynamodb_table = "mirzasa-terraform"
        key = "terraform.tfstate"
    }
}