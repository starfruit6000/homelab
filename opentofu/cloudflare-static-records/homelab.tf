data "cloudflare_zones" "homelab" {
  name = "parents-basement.win"
}

resource "cloudflare_dns_record" "pbvpn_cname" {
  content = "hkj0ah4db6f.sn.mynetname.net"
  name    = "pbvpn.home.${data.cloudflare_zones.homelab.name}"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}

resource "cloudflare_dns_record" "echoes_home" {
  content = "10.2.137.20"
  name    = "echoes.home.${data.cloudflare_zones.homelab.name}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}

resource "cloudflare_dns_record" "dogs_home" {
  content = "10.2.137.30"
  name    = "dogs.home.${data.cloudflare_zones.homelab.name}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}

resource "cloudflare_dns_record" "echoes_local_home" {
  content = "192.168.122.21"
  name    = "echoes-local.home.${data.cloudflare_zones.homelab.name}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}

resource "cloudflare_dns_record" "dogs_local_home" {
  content = "192.168.122.30"
  name    = "dogs-local.home.${data.cloudflare_zones.homelab.name}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}

resource "cloudflare_dns_record" "root_gh_pages_1" {
  content = "185.199.108.153"
  name    = data.cloudflare_zones.homelab.name
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}

resource "cloudflare_dns_record" "root_gh_pages_2" {
  content = "185.199.109.153"
  name    = data.cloudflare_zones.homelab.name
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}

resource "cloudflare_dns_record" "root_gh_pages_3" {
  content = "185.199.110.153"
  name    = data.cloudflare_zones.homelab.name
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}

resource "cloudflare_dns_record" "root_gh_pages_4" {
  content = "185.199.111.153"
  name    = data.cloudflare_zones.homelab.name
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}

resource "cloudflare_dns_record" "minecraft" {
  content = "34.118.93.238"
  name    = "minecraft.${data.cloudflare_zones.homelab.name}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}

resource "cloudflare_dns_record" "drasl" {
  content = "8.232.95.89"
  name    = "drasl.${data.cloudflare_zones.homelab.name}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.homelab.result[0].id
}
