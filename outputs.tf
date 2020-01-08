output "bucket" {
  value = aws_s3_bucket.statuspage.id
}

output "admin_access_key" {
  value = aws_iam_access_key.admin.id
}

output "admin_secret_access_key" {
  value = aws_iam_access_key.admin.secret
}

output "viewer_access_key" {
  value = aws_iam_access_key.viewer.id
}

output "viewer_secret_access_key" {
  value = aws_iam_access_key.viewer.secret
}
