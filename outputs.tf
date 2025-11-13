output "resource_group_name" {
  description = "Name of the Azure Resource Group"
  value       = azurerm_resource_group.ignite.name
}

output "vnet_name" {
  description = "Name of the Azure VNet"
  value       = azurerm_virtual_network.ignite_vnet.name
}

output "expressroute_circuit_id" {
  description = "ID of the ExpressRoute circuit"
  value       = azurerm_express_route_circuit.existing_circuit.id
}

output "fabric_primary_connection_id" {
  description = "ID of the primary Equinix Fabric connection"
  value       = equinix_fabric_connection.azure_er_l2.id
}

output "fabric_secondary_connection_id" {
  description = "ID of the secondary Equinix Fabric connection (if enabled)"
  value       = try(equinix_fabric_connection.azure_er_l2_secondary[0].id, null)
}

output "fabric_metro_and_bandwidth" {
  description = "Fabric metro and bandwidth summary for demo"
  value       = "${var.fabric_metro_code} @ ${var.fabric_bandwidth_mbps} Mbps"
}
