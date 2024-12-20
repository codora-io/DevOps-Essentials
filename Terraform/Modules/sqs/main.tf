#SQS Resource block for SQS Queue.
resource "aws_sqs_queue" "sqs_queue" {
  name                       = var.queue_name
  fifo_queue                 = var.fifo_queue
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  redrive_policy = var.dlq_enabled ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_queue_dead_letter[0].arn
    maxReceiveCount     = 4
  }) : var.redrive_policy

  tags = {
    Name        = var.queue_name
    Environment = var.environment
    Terraform   = "Yes"
  }
}

resource "aws_sqs_queue" "sqs_queue_dead_letter" {
  count = var.dlq_enabled ? 1 : 0

  name                       = "${var.queue_name}-dlq"
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds


  tags = {
    Name        = "${var.queue_name}-dlq"
    Environment = var.environment
    Terraform   = "Yes"
  }
}
