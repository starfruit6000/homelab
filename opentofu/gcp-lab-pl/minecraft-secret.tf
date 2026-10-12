resource "random_password" "minecraft_velocity_forwarding" {
  length  = 64
  special = false
}

resource "google_secret_manager_secret" "minecraft_velocity_forwarding" {
  project   = var.project_id
  secret_id = "minecraft-velocity-forwarding-secret"

  replication {
    auto {}
  }

  depends_on = [google_project_service.this["secretmanager.googleapis.com"]]
}

resource "google_secret_manager_secret_version" "minecraft_velocity_forwarding" {
  secret      = google_secret_manager_secret.minecraft_velocity_forwarding.id
  secret_data = random_password.minecraft_velocity_forwarding.result
}

resource "google_secret_manager_secret_iam_member" "minecraft_velocity_forwarding" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.minecraft_velocity_forwarding.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "principal://iam.googleapis.com/projects/${data.google_project.this.number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/gcp-lab-pl/sa/paper"
}

output "minecraft_velocity_forwarding_secret_resource_name" {
  description = "Secret Manager resource name to reference from the GKE Secret Manager CSI driver."
  value       = google_secret_manager_secret.minecraft_velocity_forwarding.name
}
