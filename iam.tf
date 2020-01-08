data "aws_iam_policy" "s3_read_only_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

data "aws_iam_policy" "s3_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user" "admin" {
  name = "${replace(var.url, ".", "-dot-")}_admin"
}

resource "aws_iam_access_key" "admin" {
  user = aws_iam_user.admin.name
}

resource "aws_iam_user_policy_attachment" "admin" {
  user       = aws_iam_user.admin.name
  policy_arn = data.aws_iam_policy.s3_full_access.arn
}

resource "aws_iam_user" "viewer" {
  name = "${replace(var.url, ".", "-dot-")}_viewer"
}

resource "aws_iam_access_key" "viewer" {
  user = aws_iam_user.viewer.name
}

resource "aws_iam_user_policy_attachment" "viewer" {
  user       = aws_iam_user.viewer.name
  policy_arn = data.aws_iam_policy.s3_read_only_access.arn
}

