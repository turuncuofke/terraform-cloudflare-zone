resource "cloudflare_rate_limit" "default" {
  for_each = var.cloudflare_rate_limits

  zone_id             = local.zone_id
  threshold           = each.value.threshold
  period              = each.value.period
  action {
    mode = each.value.action.mode
    timeout = lookup(each.value.action, "timeout", null)
    dynamic "response" {
      for_each = contains(keys(each.value.action), "response") ? [1] : []
      content {
        content_type = each.value.action.response.content_type
        body = each.value.action.response.body
      }
    }
  }
  dynamic "match" {
    for_each = contains(keys(each.value), "match") ? [1] : []
    content {
      dynamic "request" {
        for_each = contains(keys(each.value.match), "request") ? [1] : []
        content {
          url_pattern =  lookup(each.value.match.request, "url_pattern", null)
          schemes = lookup(each.value.match.request, "schemes", null)
          methods = lookup(each.value.match.request, "methods", null)
        }
      }
      dynamic "response" {
        for_each = contains(keys(each.value.match), "response") ? [1] : []
        content {
          statuses = lookup(each.value.match.response, "statuses", null)
          origin_traffic = lookup(each.value.match.response, "origin_traffic", null)
          headers = each.value.match.response.headers
        }
      }
    }
  }
  disabled            = lookup(each.value, "disabled", null)
  description         = lookup(each.value, "description", null)
  bypass_url_patterns = lookup(each.value, "bypass_url_patterns", null)
  dynamic "correlate" {
    for_each = contains(keys(each.value), "correlate") ? [1] : []
    content {
      by = each.value.correlate.by
    }
  }
}