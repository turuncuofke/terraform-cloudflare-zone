variable "zone" {
  type        = string
  description = "The DNS zone name which will be added."
}

variable "account_id" {
  type        = string
  description = "Configure API client to always use a specific account."
}

variable "zone_enabled" {
  type        = bool
  description = "Whether to create DNS zone otherwise use existing."
  default     = true
}

variable "records" {
  type        = map(any)
  default     = {}
  description = <<-DOC
    name:
      The name of the record.
    type:
      The type of the record.
    value:
      The value of the record.
    ttl:
      The TTL of the record.
      Default value: 1.
    priority:
      The priority of the record. 
    proxied:
      Whether the record gets Cloudflare's origin protection. 
      Default value: false.
  DOC
}

variable "access_rules" {
  type        = map(any)
  default     = {}
  description = <<-DOC
    configuration:
      Rule configuration to apply to a matched request. Required values:
        target: The request property to target.
        value: The value to target. Depends on target's type.
    mode:
      The action to apply to a matched request.
    notes:
      A personal note about the rule. Typically used as a reminder or explanation for the rule.
  DOC
}

variable "cloudflare_rate_limits" {
  type        = map(any)
  default     = {}
  description = <<-DOC
    threshold:
      The threshold that triggers the rate limit mitigations.
    period:
      The time in seconds to count matching traffic. If the count exceeds threshold within this period the action will be performed
    action:
      The action to be performed when the threshold of matched traffic within the period defined is exceeded.
    match:
      Determines which traffic the rate limit counts towards the threshold.
    disabled:
      Whether this ratelimit is currently disabled.
    description:
      A note that you can use to describe the reason for a rate limit.
    bypass_url_patterns:
      URLs matching the patterns specified here will be excluded from rate limiting.
    correlate:
      Determines how rate limiting is applied. By default if not specified, rate limiting applies to the clients IP address.
  DOC
}

variable "cloudflare_rulesets" {
  type        = map(any)
  default     = {}
  description = <<-DOC
    kind: 
      Type of Ruleset to create.
    name: 
      Name of the ruleset.
    phase: 
      Point in the request/response lifecycle where the ruleset will be created.
    description: 
      Brief summary of the ruleset and its intended use.
    rules: 
      (Block List) List of rules to apply to the ruleset. Rules parameters:
        expression:
          Criteria for an HTTP request to trigger the ruleset rule action.
        action:
          Action to perform in the ruleset rule.
        action_parameters: 
          (Block List, Max: 1) List of parameters that configure the behavior of the ruleset rule action.
        description:
          Brief summary of the ruleset rule and its intended use.
        enabled:
          Whether the rule is active.
        exposed_credential_check:
          (Block List, Max: 1) List of parameters that configure exposed credential checks.
        logging:
          (Block List, Max: 1) List parameters to configure how the rule generates logs.
        ratelimit:
          (Block List, Max: 1) List of parameters that configure HTTP rate limiting behaviour.
  DOC
}

variable "cloudflare_zone_lockdowns" {
  type        = map(any)
  default     = {}
  description = <<-DOC
    description:
      A description about the lockdown entry. Typically used as a reminder or explanation for the lockdown.
    urls:
      A list of simple wildcard patterns to match requests against. The order of the urls is unimportant.
    configurations:
      A list of IP addresses or IP ranges to match the request against specified in target, value pairs. Configurations parameters:
        target: 
          The request property to target.
        value:
          The value to target. Depends on target's type.
    paused:
      Boolean of whether this zone lockdown is currently paused.
  DOC
}

variable "paused" {
  type        = bool
  description = "Whether this zone is paused (traffic bypasses Cloudflare)"
  default     = false
}

variable "jump_start" {
  type        = bool
  description = "Whether to scan for DNS records on creation."
  default     = false
}

variable "plan" {
  type        = string
  description = "The name of the commercial plan to apply to the zone. Possible values: `free`, `pro`, `business`, `enterprise`"
  default     = "free"

  validation {
    condition     = var.plan == null ? true : contains(["free", "pro", "business", "enterprise"], var.plan)
    error_message = "Allowed values: `free`, `pro`, `business`, `enterprise`."
  }
}

variable "type" {
  type        = string
  description = "A full zone implies that DNS is hosted with Cloudflare. A `partial` zone is typically a partner-hosted zone or a CNAME setup. Possible values: `full`, `partial`."
  default     = "full"

  validation {
    condition     = var.type == null ? true : contains(["full", "partial"], var.type)
    error_message = "Allowed values: `full`, `partial`."
  }
}

variable "argo_enabled" {
  type        = bool
  description = "Whether to enable Cloudflare Argo for DNS zone"
  default     = false
}

variable "argo_tiered_caching_enabled" {
  type        = bool
  description = "Whether tiered caching is enabled."
  default     = true
}

variable "argo_smart_routing_enabled" {
  type        = bool
  description = "Whether smart routing is enabled."
  default     = true
}

variable "healthchecks" {
  type        = list(any)
  default     = null
  description = <<-DOC
  A list of maps of Health Checks rules. 
  The values of map is fully compliant with `cloudflare_healthcheck` resource.
  To get more info see https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/healthcheck
  DOC
}

variable "firewall_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
    paused:
      Whether this filter is currently paused.
    expression:
      The filter expression to be used.
    description:
      A note that you can use to describe the purpose of the filter and rule.
    ref:
      Short reference tag to quickly select related rules.
    action:
      The action to apply to a matched request. 
      Possible values: `block`, `challenge`, `allow`, `js_challenge`, `bypass`.
    priority:
      The priority of the rule to allow control of processing order. 
      A lower number indicates high priority.
      If not provided, any rules with a priority will be sequenced before those without.
    products:
      List of products to bypass for a request when the bypass action is used. 
      Possible values: `zoneLockdown`, `uaBlock`, `bic`, `hot`, `securityLevel`, `rateLimit`, `waf`.
  DOC
}

variable "page_rules" {
  type        = list(any)
  default     = null
  description = <<-DOC
  A list of maps of Page Rules. 
  The values of map is fully compliant with `cloudflare_page_rule` resource.
  To get more info see https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/cloudflare_page_rule
  DOC
}
