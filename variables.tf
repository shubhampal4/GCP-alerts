variable "project_id" {
  description = "The project ID where the resources are located."
  type        = string
}

variable "label_key" {
  description = "The key of the label to filter resources."
  type        = string
}

variable "label_value" {
  description = "The value of the label to filter resources."
  type        = string
}

variable "notification_email" {
  description = "The email address to send notifications."
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization threshold."
  type        = number
  default     = 0.8
}

variable "network_threshold" {
  description = "Network received bytes count threshold."
  type        = number
  default     = 1000000
}

variable "disk_threshold" {
  description = "Disk read/write bytes count threshold."
  type        = number
  default     = 1000000
}
