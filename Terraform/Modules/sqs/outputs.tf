output "sqs_id" {
  value = aws_sqs_queue.sqs_queue.id
}
output "sqs_arn" {
  value = aws_sqs_queue.sqs_queue.arn
}
output "sqs_url" {
  value = aws_sqs_queue.sqs_queue.url
}
output "sqs_dlq_id" {
  value = length(aws_sqs_queue.sqs_queue_dead_letter) > 0 ? aws_sqs_queue.sqs_queue_dead_letter[0].id : null
}
output "sqs_dlq_arn" {
  value = length(aws_sqs_queue.sqs_queue_dead_letter) > 0 ? aws_sqs_queue.sqs_queue_dead_letter[0].arn : null
}
output "sqs_dlq_url" {
  value = length(aws_sqs_queue.sqs_queue_dead_letter) > 0 ? aws_sqs_queue.sqs_queue_dead_letter[0].url : null
}
output "queue_name" {
  value = aws_sqs_queue.sqs_queue.name
}