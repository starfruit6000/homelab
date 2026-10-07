variable "grafana_url" {
  type    = string
  default = "https://parentsxbasement.grafana.net"
}

variable "prometheus_datasource_uid" {
  description = "The UID of your Grafana Cloud Prometheus data source"
  type        = string
  default     = "parentsxbasement-prom"
}
