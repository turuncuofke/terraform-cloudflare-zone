resource "cloudflare_rate_limit" "default" {
  for_each = var.cloudflare_rate_limits

  zone_id             = local.zone_id
  threshold           = each.value.threshold
  period              = each.value.period
  action {
    mode = each.value.action.mode
    timeout = lookup(each.value.action, "timeout", null)
    response {
      content_type = each.value.action.response.content_type
      body = each.value.action.response.body
    }
  }
  match {
    request {
      url_pattern = lookup(each.value.match.request, "url_pattern", null)
      schemes = lookup(each.value.match.request, "schemes", null)
      methods = lookup(each.value.match.request, "methods", null)
    }
    response {
      statuses = lookup(each.value.match.response, "statuses", null)
      origin_traffic = lookup(each.value.match.response, "origin_traffic", null)
      headers = lookup(each.value.match.response, "headers", null)
    }
  }
  disabled            = lookup(each.value, "disabled", null)
  description         = lookup(each.value, "description", null)
  bypass_url_patterns = lookup(each.value, "bypass_url_patterns", null)
  correlate {
    by = lookup(each.value.correlate, "by", null)
  }
}