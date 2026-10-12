resource "google_cloudbuildv2_connection" "github" {
  project  = var.project_id
  location = var.region
  name     = "gcp-lab-pl"

  github_config {
    app_installation_id = 170325755
    authorizer_credential {
      oauth_token_secret_version = "projects/gcp-lab-pl-fed059c83c5b8ef0/locations/europe-central2/secrets/gcp-lab-pl-github-oauthtoken-4138de/versions/latest"
    }
  }
}

resource "google_cloudbuildv2_repository" "paper_oci" {
  project           = var.project_id
  location          = var.region
  name              = "starfruit6000-paper-oci"
  parent_connection = "gcp-lab-pl"
  remote_uri        = "https://github.com/starfruit6000/paper-oci.git"
  annotations       = {}
}

#resource "google_artifact_registry_repository_iam_member" "paper_oci_builder_writer" {
#  project    = var.project_id
#  location   = google_artifact_registry_repository.oci.location
#  repository = google_artifact_registry_repository.oci.repository_id
#  role       = "roles/artifactregistry.writer"
#  member     = "serviceAccount:${google_service_account.paper_oci_builder.email}"
#}

#resource "google_service_account" "paper_oci_builder" {
#  project      = var.project_id
#  account_id   = "paper-oci-builder"
#  display_name = "Paper OCI Cloud Build"
#  description  = "Builds and pushes the Paper OCI image to Artifact Registry."
#}
#
#resource "google_project_iam_member" "paper_oci_builder_logs" {
#  project = var.project_id
#  role    = "roles/logging.logWriter"
#  member  = "serviceAccount:${google_service_account.paper_oci_builder.email}"
#}
#
#resource "google_cloudbuild_trigger" "paper_oci_manual" {
#  project         = var.project_id
#  location        = var.region
#  name            = "paper-oci-manual"
#  service_account = google_service_account.paper_oci_builder.id
#
#  build {
#    step {
#      name = "gcr.io/cloud-builders/bazel"
#      args = ["run", "//:paper_push"]
#    }
#
#    options {
#      logging = "CLOUD_LOGGING_ONLY"
#    }
#  }
#
#  depends_on = [google_project_iam_member.paper_oci_builder_logs]
#}
