provider "google" {
  project = var.project_id
  
}

# External script to fetch Compute Engine instances based on labels
data "external" "compute_instances" {
  program = ["python3", "fetch_resources.py", "compute", "v1", var.project_id, var.label_key, var.label_value, "instances", "aggregatedList", "items"]
}

locals {
  instance_ids = [for k, v in data.external.compute_instances.result : v]
}

# External script to fetch GCS buckets based on labels
data "external" "gcs_buckets" {
  program = ["python3", "fetch_resources.py", "storage", "v1", var.project_id, var.label_key, var.label_value, "buckets", "list", "items"]
}

locals {
  bucket_ids = [for k, v in data.external.gcs_buckets.result : v]
}

# Call the VM alert module
module "vm_alerts" {
  source = "./vm-alert_module"

  project_id         = var.project_id
  instance_ids       = local.instance_ids
  notification_email = var.notification_email
  cpu_threshold      = var.cpu_threshold
  network_threshold  = var.network_threshold
  disk_threshold     = var.disk_threshold
}

# # Call the Cloud Run alert module
# module "cloud_run_alerts" {
#   source = "./cloud-run-alert_module"

#   project_id         = var.project_id
#   notification_email = var.notification_email
# }

# Call the Composer alert module
# module "composer_alerts" {
#   source = "./composer-alert_module"

#   project_id         = var.project_id
#   notification_email = var.notification_email
# }

# Call the GCS alert module
module "gcs_alerts" {
  source = "./gcs-alert_module"

  project_id         = var.project_id
  bucket_ids         = local.bucket_ids
  notification_email = var.notification_email
}
