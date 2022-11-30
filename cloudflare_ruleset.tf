resource "cloudflare_ruleset" "rate_limiting_example" {
  for_each = var.cloudflare_rulesets

  zone_id     = local.zone_id
  name        = each.value.name
  description = each.value.description
  kind        = each.value.kind
  phase       = each.value.phase

  rules {
    action = each.value.rules.action
    ratelimit {
      characteristics     = lookup(each.value.rules.ratelimit, "characteristics", null)
      period              = lookup(each.value.rules.ratelimit, "period", null)
      requests_per_period = lookup(each.value.rules.ratelimit, "requests_per_period", null)
      mitigation_timeout  = lookup(each.value.rules.ratelimit, "mitigation_timeout", null)
    }

    expression  = lookup(each.value.rules, "expression", null)
    description = lookup(each.value.rules, "description", null)
    enabled     = lookup(each.value.rules, "enabled", null)
  }
}