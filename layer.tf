data "archive_file" "checkup" {
  type        = "zip"
  source_dir  = "layer"
  output_path = "layer.zip"
}

resource "aws_lambda_layer_version" "checkup" {
  filename         = data.archive_file.checkup.output_path
  layer_name       = "checkup"
  source_code_hash = data.archive_file.checkup.output_base64sha256
}
