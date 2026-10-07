resource "grafana_dashboard" "debian_overview" {
  folder      = grafana_folder.infrastructure.id
  config_json = file("${path.module}/dashboards/debian_overview.json")
  overwrite   = true
}

resource "grafana_dashboard" "public_starter" {
  folder = grafana_folder.infrastructure.id
  config_json = file("${path.module}/dashboards/public_starter.json")
  overwrite   = true
}

resource "grafana_dashboard_public" "public_starter" {
  dashboard_uid          = grafana_dashboard.public_starter.uid
  is_enabled             = true
  share                  = "public"
  time_selection_enabled = false
  annotations_enabled    = false
}
