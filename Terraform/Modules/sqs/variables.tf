variable "name" {
  type        = string
  description = "Solution name, which could be your organization name, e.g. 'eg' or 'cp'"
}
variable "environment" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}
variable "queue_name" {
  type = string
}
variable "fifo_queue" {
  description = "Boolean designating a FIFO queue"
  default     = false
}
variable "dlq_enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any sqs-dql resources"
}
variable "delay_seconds" {
  type    = number
  default = 10
}
variable "max_message_size" {
  type        = number
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  default     = 262144
}
variable "message_retention_seconds" {
  type    = number
  default = 86400
}
variable "visibility_timeout_seconds" {
  type        = number
  default     = 200
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
}
variable "receive_wait_time_seconds" {
  type        = number
  default     = 10
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
}
variable "redrive_policy" {
  description = "The JSON policy to set up the Dead Letter Queue, see AWS docs. Note= when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
  default     = ""
}
