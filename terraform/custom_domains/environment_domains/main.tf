# Used to create domains to be managed by front door.
module "domains" {
  for_each              = var.hosted_zone
  source                = "git::https://github.com/DFE-Digital/terraform-modules.git//domains/environment_domains?ref=stable"
  zone                  = each.key
  front_door_name       = each.value.front_door_name
  resource_group_name   = each.value.resource_group_name
  domains               = each.value.domains
  environment           = each.value.environment_short
  redirect_rules        = try(each.value.redirect_rules, [])
}

# Takes values from hosted_zone.domain_name.cnames (or txt_records, a-records). Use for domains which are not associated with front door.
module "dns_records" {
  source      = "git::https://github.com/DFE-Digital/terraform-modules.git//dns/records?ref=stable"
  hosted_zone = var.hosted_zone
}
