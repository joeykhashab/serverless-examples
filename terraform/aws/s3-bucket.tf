resource "aws_s3_bucket" "batch-data-example" {
  bucket = "serverless-test-data-bucket-example"
  acl    = "private"
}
