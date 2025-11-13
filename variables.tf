############################################
# Azure side
############################################

output "azure_resource_group_name" {
  description = "Resource group used by the ExpressRoute circuit"
  value       = module.equinix_fabric_connection_azure.azure_resource_group_name
}

output "azure_expressroute_circuit_id" {
  description = "ID of the ExpressRoute circuit created by the module"
  value       = module.equinix_fabric_connection_azure.azure_expressroute_circuit_id
}

############################################
# Fabric connection (primary)
############################################

output "fabric_primary_connection_uuid" {
  description = "Primary Fabric connection UUID"
  value       = module.equinix_fabric_connection_azure.fabric_connection_primary_uuid
}

output "fabric_primary_connection_name" {
  description = "Primary Fabric connection name"
  value       = module.equinix_fabric_connection_azure.fabric_connection_primary_name
}

output "fabric_primary_connection_status" {
  description = "Primary Fabric connection provisioning status"
  value       = module.equinix_fabric_connection_azure.fabric_connection_primary_status
}

output "fabric_primary_connection_provider_status" {
  description = "Primary Fabric connection provider status"
  value       = module.equinix_fabric_connection_azure.fabric_connection_primary_provider_status
}

output "fabric_primary_connection_speed" {
  description = "Primary Fabric connection speed and unit"
  value       = "${module.equinix_fabric_connection_azure.fabric_connection_primary_speed} ${module.equinix_fabric_connection_azure.fabric_connection_primary_speed_unit}"
}

output "fabric_primary_connection_seller_metro" {
  description = "Primary Fabric connection seller metro"
  value       = module.equinix_fabric_connection_azure.fabric_connection_primary_seller_metro
}

############################################
# Fabric connection (secondary, if REDUNDANT)
############################################

output "fabric_secondary_connection_uuid" {
  description = "Secondary Fabric connection UUID (if REDUNDANT)"
  value       = module.equinix_fabric_connection_azure.fabric_connection_secondary_uuid
}

output "fabric_secondary_connection_name" {
  description = "Secondary Fabric connection name (if REDUNDANT)"
  value       = module.equinix_fabric_connection_azure.fabric_connection_secondary_name
}

output "fabric_secondary_connection_status" {
  description = "Secondary Fabric connection provisioning status (if REDUNDANT)"
  value       = module.equinix_fabric_connection_azure.fabric_connection_secondary_status
}

output "fabric_secondary_connection_provider_status" {
  description = "Secondary Fabric connection provider status (if REDUNDANT)"
  value       = module.equinix_fabric_connection_azure.fabric_connection_secondary_provider_status
}
