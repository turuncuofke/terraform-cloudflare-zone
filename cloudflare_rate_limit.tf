resource "cloudflare_rate_limit" "default" {
  for_each = var.cloudflare_rate_limits

  zone_id             = local.zone_id
  threshold           = each.value.threshold
  period              = each.value.period
  action {
    mode = each.value.action.mode
    timeout = lookup(each.value.action, "timeout", null)
  }
  disabled            = lookup(each.value, "disabled", null)
  description         = lookup(each.value, "description", null)
  bypass_url_patterns = lookup(each.value, "bypass_url_patterns", null)
}