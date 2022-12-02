resource "cloudflare_zone_lockdown" "default" {
  for_each = var.cloudflare_zone_lockdowns

  zone_id     = local.zone_id
  paused      = lookup(each.value, "paused", false)
  description = lookup(each.value, "description", "")
  urls = each.value.urls
  dynamic "configurations" {
    for_each = each.value.configurations.values
    content {
      target = each.value.configurations.target
      value = configurations.value
    }
  }
}