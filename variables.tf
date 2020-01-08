variable "url" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "checkup_interval" {
  type    = string
  default = "5 minutes"
}