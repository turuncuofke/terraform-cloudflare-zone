resource "cloudflare_ruleset" "default" {
  for_each = var.cloudflare_rulesets

  zone_id     = local.zone_id
  name        = each.value.name
  description = each.value.description
  kind        = each.value.kind
  phase       = each.value.phase
  dynamic "rules" {
    for_each = each.value.rules
      content {
        action = rules.value["action"]
        ratelimit {
          characteristics     = lookup(rules.value["ratelimit"], "characteristics", null)
          period              = lookup(rules.value["ratelimit"], "period", null)
          requests_per_period = lookup(rules.value["ratelimit"], "requests_per_period", null)
          mitigation_timeout  = lookup(rules.value["ratelimit"], "mitigation_timeout", null)
        }

        expression  = lookup(rules.value, "expression", null)
        description = lookup(rules.value, "description", null)
        enabled     = lookup(rules.value, "enabled", null)
      }
    }
}