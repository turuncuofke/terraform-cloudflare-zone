resource "cloudflare_access_rule" "default" {
  for_each = var.access_rules

  zone_id       = local.zone_id
  notes         = lookup(each.value, "notes", null)
  mode          = each.value.mode
  configuration {
    target = each.value.configuration.target
    value = each.value.configuration.value
  }
}