output "public_starter_dashboard_url" {
  description = "Public link to the empty starter dashboard. Anyone with the link can view it."
  value       = "${trimsuffix(var.grafana_url, "/")}/public-dashboards/${grafana_dashboard_public.public_starter.access_token}"
}
