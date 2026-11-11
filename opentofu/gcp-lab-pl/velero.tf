resource "google_storage_bucket" "velero" {
  name                        = "${var.project_id}-velero"
  project                     = var.project_id
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  # Velero expires backups and maintains Kopia's shared chunks. An age-based
  # bucket lifecycle would delete chunks that newer backups still reference.
  depends_on = [google_project_service.this["storage.googleapis.com"]]
}

resource "google_service_account" "velero" {
  project      = var.project_id
  account_id   = "velero"
  display_name = "Velero GCS backup and restore"
}

resource "google_service_account_iam_member" "velero_workload_identity" {
  service_account_id = google_service_account.velero.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[velero/velero]"
}

resource "google_storage_bucket_iam_member" "velero" {
  bucket = google_storage_bucket.velero.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.velero.email}"
}

# The GCP plugin uses signed URLs for CLI logs, describe, and download.
resource "google_service_account_iam_member" "velero_sign_urls" {
  service_account_id = google_service_account.velero.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.velero.email}"
}

resource "random_password" "velero_repository" {
  length  = 48
  special = false
}

resource "google_secret_manager_secret" "velero_repository" {
  project   = var.project_id
  secret_id = "velero-repository-password"

  replication {
    auto {}
  }

  depends_on = [google_project_service.this["secretmanager.googleapis.com"]]
}

resource "google_secret_manager_secret_version" "velero_repository" {
  secret      = google_secret_manager_secret.velero_repository.id
  secret_data = random_password.velero_repository.result
}

output "velero_bucket" {
  description = "Velero metadata and Kopia volume data. Retention is managed by Velero."
  value       = "gs://${google_storage_bucket.velero.name}"
}
