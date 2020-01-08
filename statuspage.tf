resource "aws_s3_bucket_object" "css" {
  for_each = fileset(path.module, "checkup/statuspage/css/*.css")

  bucket       = aws_s3_bucket.statuspage.id
  key          = replace(each.value, "checkup/statuspage/", "")
  source       = each.value
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "pngs" {
  for_each = fileset(path.module, "checkup/statuspage/images/*.png")

  bucket       = aws_s3_bucket.statuspage.id
  key          = replace(each.value, "checkup/statuspage/", "")
  source       = each.value
  content_type = "image/png"
}

resource "aws_s3_bucket_object" "js" {
  for_each = fileset(path.module, "checkup/statuspage/js/*.js")

  bucket       = aws_s3_bucket.statuspage.id
  key          = replace(each.value, "checkup/statuspage/", "")
  source       = each.value
  content_type = "text/javascript"
}

resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.statuspage.id
  key          = "index.html"
  source       = "checkup/statuspage/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "config" {
  depends_on = [aws_s3_bucket_object.js]

  bucket = aws_s3_bucket.statuspage.id
  key    = "js/config.js"
  content = templatefile("config.js", {
    access_key_id     = aws_iam_access_key.viewer.id,
    secret_access_key = aws_iam_access_key.viewer.secret,
    region            = var.aws_region,
    bucket_name       = aws_s3_bucket.statuspage.id,
  })
  content_type = "text/javascript"
}
