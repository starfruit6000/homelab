resource "google_gke_backup_backup_plan" "paper_daily" {
  name        = "paper-daily"
  project     = var.project_id
  location    = var.region
  cluster     = google_container_cluster.gcp_lab.id
  description = "Daily backups of Paper configuration and persistent world data"

  backup_config {
    include_volume_data = true
    include_secrets     = true

    selected_namespaces {
      namespaces = ["gcp-lab-pl"]
    }
  }

  backup_schedule {
    cron_schedule = "0 3 * * *"
    paused        = false
  }

  retention_policy {
    backup_retain_days = 7
  }

  depends_on = [google_project_service.this["gkebackup.googleapis.com"]]
}
