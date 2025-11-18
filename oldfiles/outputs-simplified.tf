# Outputs for Azure ExpressRoute + Equinix Fabric Demo

output "resource_group_name" {
  description = "The name of the Azure resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "expressroute_gateway_id" {
  description = "The ID of the ExpressRoute gateway"
  value       = azurerm_virtual_network_gateway.expressroute.id
}

output "expressroute_circuit_id" {
  description = "The ID of the ExpressRoute circuit"
  value       = azurerm_express_route_circuit.main.id
}

output "expressroute_service_key" {
  description = "The service key for the ExpressRoute circuit - use this to configure Equinix Fabric"
  value       = azurerm_express_route_circuit.main.service_key
  sensitive   = true
}

output "expressroute_circuit_name" {
  description = "The name of the ExpressRoute circuit"
  value       = azurerm_express_route_circuit.main.name
}

output "configuration_summary" {
  description = "Summary of the configuration"
  value = {
    environment = var.env_name
    region      = var.azure_region
    metro       = var.fabric_destination_metro_code
    bandwidth   = "${var.fabric_speed} Mbps"
  }
}
