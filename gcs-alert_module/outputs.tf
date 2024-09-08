# output "notification_channel_id" {
#   value = google_monitoring_notification_channel.email.id
# }

# output "storage_alert_ids" {
#   value = [for k, v in google_monitoring_alert_policy.storage_alert : v.id]
# }

# output "object_count_alert_ids" {
#   value = [for k, v in google_monitoring_alert_policy.object_count_alert : v.id]
# }
