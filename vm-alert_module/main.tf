resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notification Channel"
  type         = "email"

  labels = {
    "email_address" = var.notification_email
  }
}

resource "google_monitoring_alert_policy" "cpu_alert" {
  for_each    = toset(var.instance_ids)
  project     = var.project_id
  display_name = "High CPU Usage for Labeled Instance"
  combiner     = "OR"

  conditions {
    display_name = "High CPU Usage"
    condition_threshold {
      filter            = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${each.key}\""
      comparison        = "COMPARISON_GT"
      threshold_value   = var.cpu_threshold
      duration          = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  documentation {
    content  = "This alert policy triggers when the CPU usage exceeds 80% for more than 60 seconds."
    mime_type = "text/markdown"
  }

  user_labels = {
    "severity" = "critical"
  }
}

resource "google_monitoring_alert_policy" "network_alert" {
  for_each    = toset(var.instance_ids)
  project     = var.project_id
  display_name = "High Network Usage for Labeled Instance"
  combiner     = "OR"

  conditions {
    display_name = "High Network Usage"
    condition_threshold {
      filter            = "metric.type=\"compute.googleapis.com/instance/network/received_bytes_count\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${each.key}\""
      comparison        = "COMPARISON_GT"
      threshold_value   = var.network_threshold
      duration          = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  documentation {
    content  = "This alert policy triggers when the network usage exceeds the specified threshold for more than 60 seconds."
    mime_type = "text/markdown"
  }

  user_labels = {
    "severity" = "critical"
  }
}

resource "google_monitoring_alert_policy" "disk_write_alert" {
  for_each    = toset(var.instance_ids)
  project     = var.project_id
  display_name = "High Disk Write Usage for Labeled Instance"
  combiner     = "OR"

  conditions {
    display_name = "High Disk Write Usage"
    condition_threshold {
      filter            = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${each.key}\""
      comparison        = "COMPARISON_GT"
      threshold_value   = var.disk_threshold
      duration          = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  documentation {
    content  = "This alert policy triggers when the disk write usage exceeds the specified threshold for more than 60 seconds."
    mime_type = "text/markdown"
  }

  user_labels = {
    "severity" = "critical"
  }
}

resource "google_monitoring_alert_policy" "disk_read_alert" {
  for_each    = toset(var.instance_ids)
  project     = var.project_id
  display_name = "High Disk Read Usage for Labeled Instance"
  combiner     = "OR"

  conditions {
    display_name = "High Disk Read Usage"
    condition_threshold {
      filter            = "metric.type=\"compute.googleapis.com/instance/disk/read_bytes_count\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${each.key}\""
      comparison        = "COMPARISON_GT"
      threshold_value   = var.disk_threshold
      duration          = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  documentation {
    content  = "This alert policy triggers when the disk read usage exceeds the specified threshold for more than 60 seconds."
    mime_type = "text/markdown"
  }

  user_labels = {
    "severity" = "critical"
  }
}

resource "google_monitoring_alert_policy" "memory_used_alert" {
  for_each    = toset(var.instance_ids)
  project     = var.project_id
  display_name = "High Memory Usage for Labeled Instance"
  combiner     = "OR"

  conditions {
    display_name = "High Memory Usage"
    condition_threshold {
      filter            = "metric.type=\"compute.googleapis.com/instance/memory/balloon/ram_size\" AND resource.type=\"gce_instance\" AND resource.label.instance_id=\"${each.key}\""
      comparison        = "COMPARISON_GT"
      threshold_value   = var.memory_threshold
      duration          = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  documentation {
    content  = "This alert policy triggers when the memory usage exceeds 80% for more than 60 seconds."
    mime_type = "text/markdown"
  }

  user_labels = {
    "severity" = "critical"
  }
}
