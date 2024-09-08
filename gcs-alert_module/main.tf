resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notification Channel"
  type         = "email"

  labels = {
    "email_address" = var.notification_email
  }
}

resource "google_monitoring_alert_policy" "storage_alert" {
  for_each    = toset(var.bucket_ids)
  project     = var.project_id
  display_name = "High Storage Usage for Labeled Bucket"
  combiner     = "OR"

  conditions {
    display_name = "High Storage Usage"
    condition_threshold {
      filter            = "metric.type=\"storage.googleapis.com/storage/total_bytes\" AND resource.type=\"gcs_bucket\" AND resource.label.bucket_name=\"${each.key}\""
      comparison        = "COMPARISON_GT"
      threshold_value   = var.storage_threshold
      duration          = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  documentation {
    content  = "This alert policy triggers when the storage usage exceeds the specified threshold for more than 60 seconds."
    mime_type = "text/markdown"
  }

  user_labels = {
    "severity" = "critical"
  }
}

resource "google_monitoring_alert_policy" "object_count_alert" {
  for_each    = toset(var.bucket_ids)
  project     = var.project_id
  display_name = "High Object Count for Labeled Bucket"
  combiner     = "OR"

  conditions {
    display_name = "High Object Count"
    condition_threshold {
      filter            = "metric.type=\"storage.googleapis.com/storage/object_count\" AND resource.type=\"gcs_bucket\" AND resource.label.bucket_name=\"${each.key}\""
      comparison        = "COMPARISON_GT"
      threshold_value   = var.object_count_threshold
      duration          = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  documentation {
    content  = "This alert policy triggers when the object count exceeds the specified threshold for more than 60 seconds."
    mime_type = "text/markdown"
  }

  user_labels = {
    "severity" = "critical"
  }
}
