module "postgres" {
  source = "./vendor/modules/aks//aks/postgres"

  namespace             = var.namespace
  environment           = local.app_name_suffix
  azure_resource_prefix = var.azure_resource_prefix
  service_short         = var.service_short
  config_short          = var.config_short
  service_name          = local.service_name

  cluster_configuration_map = module.cluster_data.configuration_map

  use_azure               = var.deploy_azure_backing_services
  azure_enable_monitoring = var.enable_monitoring
  azure_extensions        = ["CITEXT"]
  server_version          = var.postgres_version
  azure_sku_name          = var.postgres_flexible_server_sku

  azure_enable_high_availability = var.postgres_enable_high_availability
  azure_maintenance_window       = var.azure_maintenance_window
  azure_enable_backup_storage    = var.azure_enable_backup_storage
}

module "redis" {
  source = "./vendor/modules/aks/aks/redis"

  namespace             = var.namespace
  environment           = local.app_name_suffix
  azure_resource_prefix = var.azure_resource_prefix
  service_name          = local.service_name
  service_short         = var.service_short
  config_short          = var.config_short

  cluster_configuration_map = module.cluster_data.configuration_map

  use_azure               = var.deploy_azure_backing_services
  azure_enable_monitoring = var.enable_monitoring
  azure_patch_schedule    = [{ "day_of_week": "Sunday", "start_hour_utc": 01 }]
}
