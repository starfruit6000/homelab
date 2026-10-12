resource "google_artifact_registry_repository" "oci" {
  project       = var.project_id
  location      = var.region
  repository_id = data.google_project.this.name
  format        = "DOCKER"

  depends_on = [google_project_service.this]
}

resource "google_artifact_registry_repository_iam_member" "gke_node_reader" {
  project    = var.project_id
  location   = google_artifact_registry_repository.oci.location
  repository = google_artifact_registry_repository.oci.repository_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${data.google_project.this.number}-compute@developer.gserviceaccount.com"
}
