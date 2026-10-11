data "google_billing_account" "this" {
  billing_account = "011357-BE8D2E-C2A718"
}

data "google_organization" "this" {
  organization = "388691868909"
}

resource "google_organization_iam_member" "policy_admin" {
  org_id = data.google_organization.this.org_id
  role   = "roles/orgpolicy.policyAdmin"
  member = "user:xmaciejmichalek@gmail.com"
}

resource "google_org_policy_policy" "skip_default_network_creation" {
  name   = "${data.google_organization.this.name}/policies/compute.skipDefaultNetworkCreation"
  parent = data.google_organization.this.name

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

resource "google_org_policy_custom_constraint" "skip_auto_create_subnets" {
  name         = "custom.skipAutoCreateSubnetworks"
  parent       = data.google_organization.this.name
  display_name = "skipAutoCreateSubnetworks"
  description  = "VPC networks must use custom subnet mode (autoCreateSubnetworks=false)"

  action_type    = "ALLOW"
  condition      = "resource.autoCreateSubnetworks == false"
  method_types   = ["CREATE", "UPDATE"]
  resource_types = ["compute.googleapis.com/Network"]
}

resource "google_org_policy_policy" "skip_auto_create_subnets" {
  name   = "${data.google_organization.this.name}/policies/${google_org_policy_custom_constraint.skip_auto_create_subnets.name}"
  parent = data.google_organization.this.name

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

resource "random_id" "state_project_suffix" {
  byte_length = 8
}

resource "google_project" "state" {
  name            = "state"
  project_id      = "state-${random_id.state_project_suffix.hex}"
  org_id          = data.google_organization.this.org_id
  billing_account = data.google_billing_account.this.id
  deletion_policy = "DELETE"
}

resource "google_project_service" "services" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "cloudlocationfinder.googleapis.com",
    "orgpolicy.googleapis.com",
    "cloudbilling.googleapis.com"
  ])
  project = google_project.state.project_id
  service = each.value
}

resource "random_id" "state_bucket_suffix" {
  byte_length = 8
}

resource "google_storage_bucket" "this" {
  name                        = "state-${random_id.state_bucket_suffix.hex}"
  location                    = "europe-west10"
  project                     = google_project.state.project_id
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  depends_on = [google_project_service.services]
}

output "state_bucket" {
  value = google_storage_bucket.this.name
}

locals {
  projects = toset(["gcp-lab", "gcp-lab-pl"])
}

resource "random_id" "projects" {
  for_each = local.projects

  byte_length = 8
}

resource "google_project" "projects" {
  for_each = local.projects

  name            = each.key
  project_id      = "${each.key}-${random_id.projects[each.key].hex}"
  org_id          = data.google_organization.this.org_id
  billing_account = data.google_billing_account.this.id
  deletion_policy = "DELETE"
}

output "state_bucket_prefixes" {
  value = {
    for name, project_id in google_project.projects : name => project_id.project_id
  }
}
