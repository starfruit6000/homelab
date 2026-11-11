resource "google_container_cluster" "gcp_lab" {
  enable_autopilot   = true
  location           = var.region
  min_master_version = "1.37.1-gke.1552000"
  name               = "gcp-lab"
  network            = google_compute_network.this.id
  project            = var.project_id
  subnetwork         = "projects/${var.project_id}/regions/${var.region}/subnetworks/nodes"
  # fleet {
  #   project = var.project_id
  # }
  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
    gcp_filestore_csi_driver_config {
      enabled = true
    }
    gcs_fuse_csi_driver_config {
      enabled = true
    }
    gke_backup_agent_config {
      enabled = true
    }
    http_load_balancing {
      disabled = false
    }
    parallelstore_csi_driver_config {
      enabled = true
    }
    ray_operator_config {
      enabled = false
    }
  }
  control_plane_endpoints_config {
    dns_endpoint_config {
      allow_external_traffic = true
    }
    ip_endpoints_config {
      enabled = false
    }
  }
  database_encryption {
    key_name = null
    state    = "DECRYPTED"
  }
  default_snat_status {
    disabled = false
  }
  dns_config {
    additive_vpc_scope_dns_domain = null
    cluster_dns                   = "CLOUD_DNS"
    cluster_dns_domain            = "cluster.local"
    cluster_dns_scope             = "CLUSTER_SCOPE"
  }
  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
    stack_type                    = "IPV4_IPV6"
    pod_cidr_overprovision_config {
      disabled = false
    }
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  maintenance_policy {
    recurring_window {
      end_time   = "2026-10-09T04:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU"
      start_time = "2026-10-09T00:00:00Z"
    }
  }
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS", "STORAGE", "HPA", "POD", "DAEMONSET", "DEPLOYMENT", "STATEFULSET", "CADVISOR", "KUBELET", "DCGM", "JOBSET"]
    advanced_datapath_observability_config {
      enable_metrics = true
      enable_relay   = false
    }
    managed_prometheus {
      enabled = true
      auto_monitoring_config {
        scope = "NONE"
      }
    }
  }
  node_pool_auto_config {
    resource_manager_tags = {}
    node_kubelet_config {
      insecure_kubelet_readonly_port_enabled = "FALSE"
    }
  }
  notification_config {
    pubsub {
      enabled = false
      topic   = null
    }
  }
  pod_autoscaling {
    hpa_profile = "PERFORMANCE"
  }
  private_cluster_config {
    enable_private_endpoint     = true
    enable_private_nodes        = true
    master_ipv4_cidr_block      = null
    private_endpoint_subnetwork = null
    master_global_access_config {
      enabled = false
    }
  }
  rbac_binding_config {
    enable_insecure_binding_system_authenticated   = false
    enable_insecure_binding_system_unauthenticated = false
  }
  release_channel {
    channel = "RAPID"
  }
  secret_manager_config {
    enabled = true
    rotation_config {
      enabled           = false
      rotation_interval = null
    }
  }
  security_posture_config {
    mode               = "BASIC"
    vulnerability_mode = "VULNERABILITY_DISABLED"
  }
  service_external_ips_config {
    enabled = false
  }
  vertical_pod_autoscaling {
    enabled = true
  }

  depends_on = [google_project_service.this]
}

# resource "google_gke_hub_feature" "configmanagement" {
#   name     = "configmanagement"
#   location = "global"
#
#   depends_on = [google_project_service.this]
# }
#
# resource "google_gke_hub_feature_membership" "configmanagement" {
#   location            = "global"
#   feature             = google_gke_hub_feature.configmanagement.name
#   membership          = google_container_cluster.gcp_lab.name
#   membership_location = google_container_cluster.gcp_lab.location
#
#   configmanagement {
#     config_sync {
#       enabled = true
#       oci {
#         sync_repo   = "oci://registry.gitlab.com/starfruit6000/homelab/fleet"
#         policy_dir  = "clusters/gcp-lab-pl"
#         secret_type = "none"
#       }
#     }
#   }
#
#   depends_on = [google_container_cluster.gcp_lab]
# }
