provider "aws" {
  profile   = "default"
  region    = "us-east-1"
}

resource "aws_sqs_queue" "my-queue" {
    name = "my-queue"
    delay_seconds = 90
    message_retention_seconds = 86400 
    visibility_timeout_seconds = 30
    receive_wait_time_seconds = 0
    tags = {
        Environment = "production"
    }
}

