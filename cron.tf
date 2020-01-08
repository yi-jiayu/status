resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.checkup.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_checkups.arn
}

resource "aws_cloudwatch_event_rule" "schedule_checkups" {
  name = "schedule-checkups-for-${replace(var.bucket, ".", "-dot-")}"

  schedule_expression = "rate(${var.checkup_interval})"
}

resource "aws_cloudwatch_event_target" "run_checkups" {
  arn  = aws_lambda_function.checkup.arn
  rule = aws_cloudwatch_event_rule.schedule_checkups.name
}