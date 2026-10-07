resource "grafana_folder" "infrastructure" {
  title = "Infrastructure Alerts"
}

#resource "grafana_contact_point" "sysadmin" {
#  name = "Sysadmin Email Alerts"
#
#  email {
#    addresses               = [data.sops_file.grafana_secrets.data["alert_email_address"]]
#    single_email            = true
#    disable_resolve_message = false
#  }
#
#  # this is not availabe in terraform right now
#  irm {}
#}
#IRM and everything related to it managed in the UI because of terraform limitations

resource "grafana_notification_policy" "infrastructure_routing" {
  group_by      = ["grafana_folder", "alertname"]
  contact_point = "sysadmin"

  policy {
    matcher {
      label = "alertname"
      match = "="
      value = "DatasourceError"
    }
    matcher {
      label = "datasource_uid"
      match = "="
      value = data.grafana_data_source.prometheus.uid
    }

    contact_point = "sysadmin"
    group_by      = ["datasource_uid", "rulename"]
    group_wait    = "24h"
  }

  policy {
    matcher {
      label = "team"
      match = "="
      value = "sysadmin"
    }
    #    contact_point = grafana_contact_point.sysadmin.name
    contact_point = "sysadmin"
  }
}
