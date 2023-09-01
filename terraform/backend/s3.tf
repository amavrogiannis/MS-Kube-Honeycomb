provider "aws" {
  profile = "and"
  region  = "eu-west-2"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "tf-hc-backend"
  object_lock_enabled = true
  tags = {
    Contact = "alex.mavrogiannis"
    Project  = "Honeycombio-Demo"
  }
}
resource "aws_s3_bucket_versioning" "bucket" {
    bucket = aws_s3_bucket.bucket.id
    versioning_configuration {
      status = "Enabled"
    }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket"{
    bucket = aws_s3_bucket.bucket.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_dynamodb_table" "terraform-lock" {
  name           = "alexm-backend"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Contact  = "alex.mavrogiannis"
    Project  = "Honeycombio-Demo"
  }
}