resource "cloudflare_logpush_ownership_challenge" "default" {
  for_each         = var.logging_options

  zone_id          = local.zone_id
  destination_conf = each.value.destination_conf
}

data "aws_s3_object" "default" {
  for_each = var.logging_options

  bucket   = each.value.bucket
  key      = cloudflare_logpush_ownership_challenge.default[each.key].ownership_challenge_filename
}

resource "cloudflare_logpush_job" "default" {
  for_each            = var.logging_options

  zone_id             = local.zone_id
  enabled             = lookup(each.value, "enabled", true)
  name                = "${local.logpush_job_name}-${replace(each.key, "_", "-")}-logs"
  logpull_options     = each.value.logpull_options
  destination_conf    = each.value.destination_conf
  ownership_challenge = data.aws_s3_object.default[each.key].body
  dataset             = each.key
}

locals {
  logpush_job_name = split(".com", var.zone)[0]
}