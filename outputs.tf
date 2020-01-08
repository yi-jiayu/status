output "bucket" {
  value = "http://${aws_s3_bucket.statuspage.id}.s3-website.${var.aws_region}.amazonaws.com"
}
