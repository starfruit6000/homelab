resource "google_compute_network" "this" {
  project                  = var.project_id
  name                     = data.google_project.this.name
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "gke" {
  project                  = var.project_id
  name                     = "nodes"
  ip_cidr_range            = "10.6.137.0/24"
  stack_type               = "IPV4_IPV6"
  ipv6_access_type         = "INTERNAL"
  private_ip_google_access = true
  region                   = var.region
  network                  = google_compute_network.this.id

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.6.0.0/18"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.6.64.0/20"
  }
}

resource "google_compute_subnetwork" "management" {
  project          = var.project_id
  name             = "management"
  ip_cidr_range    = "10.8.137.0/24"
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "INTERNAL"
  region           = var.region
  network          = google_compute_network.this.id
}

resource "google_compute_subnetwork" "external" {
  project          = var.project_id
  name             = "external"
  ip_cidr_range    = "10.9.137.0/24"
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
  region           = var.region
  network          = google_compute_network.this.id
}

resource "google_compute_router" "gke_egress" {
  project = var.project_id
  name    = "gke-egress"
  region  = var.region
  network = google_compute_network.this.id

  #  bgp {
  #    asn = 64514
  #  }

  depends_on = [google_project_service.this["compute.googleapis.com"]]
}

resource "google_compute_router_nat" "gke_egress" {
  project                            = var.project_id
  name                               = "gke-egress"
  router                             = google_compute_router.gke_egress.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.gke.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
