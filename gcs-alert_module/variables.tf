variable "project_id" {
  description = "The project ID where the resources are located."
  type        = string
}

variable "bucket_ids" {
  description = "List of GCS bucket IDs to monitor."
  type        = list(string)
}

variable "notification_email" {
  description = "The email address to send notifications."
  type        = string
}

variable "storage_threshold" {
  description = "Storage usage threshold in bytes."
  type        = number
  default     = 1000000000  # 1GB
}

variable "object_count_threshold" {
  description = "Object count threshold."
  type        = number
  default     = 10000
}
