terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    equinix = {
      source  = "equinix/equinix"
      version = "~> 4.0"
    }
  }
}

############################################
# Providers
############################################

# AzureRM provider – assumes Azure CLI / Managed Identity auth
provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
}

# Equinix provider – configure via env vars or variables
# See: https://registry.terraform.io/providers/equinix/equinix/latest/docs
provider "equinix" {
  # Typically set via environment variables:
  # EQUINIX_CLIENT_ID, EQUINIX_CLIENT_SECRET, etc.
  # Left empty here for demo clarity.
}

############################################
# Azure side – RG + VNet + gateway
############################################

resource "azurerm_resource_group" "ignite" {
  name     = "${var.env_name}-rg"
  location = var.azure_region
}

resource "azurerm_virtual_network" "ignite_vnet" {
  name                = "${var.env_name}-vnet"
  location            = azurerm_resource_group.ignite.location
  resource_group_name = azurerm_resource_group.ignite.name
  address_space       = ["10.10.0.0/16"]
}

resource "azurerm_subnet" "ignite_subnet" {
  name                 = "${var.env_name}-subnet"
  resource_group_name  = azurerm_resource_group.ignite.name
  virtual_network_name = azurerm_virtual_network.ignite_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

# Gateway subnet required for an ExpressRoute VNet gateway
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.ignite.name
  virtual_network_name = azurerm_virtual_network.ignite_vnet.name
  address_prefixes     = ["10.10.255.0/27"]
}

resource "azurerm_public_ip" "er_gateway_pip" {
  name                = "${var.env_name}-er-gw-pip"
  resource_group_name = azurerm_resource_group.ignite.name
  location            = azurerm_resource_group.ignite.location
  allocation_method   = "Dynamic"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "er_gateway" {
  name                = "${var.env_name}-er-gw"
  resource_group_name = azurerm_resource_group.ignite.name
  location            = azurerm_resource_group.ignite.location

  type     = "ExpressRoute"
  vpn_type = "RouteBased"
  sku      = "Standard"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.er_gateway_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}

############################################
# Equinix + ExpressRoute:
# Module: equinix-labs/fabric-connection-azure/equinix
############################################
# This module:
# - Reuses (or creates) an Azure Resource Group
# - Creates an ExpressRoute circuit with Equinix as provider
# - Configures ExpressRoute peering
# - Creates a primary/secondary Equinix Fabric L2 connection
#   for Azure ExpressRoute using the service key
############################################

module "equinix_fabric_connection_azure" {
  source  = "equinix-labs/fabric-connection-azure/equinix"
  version = "0.2.0"

  ##########################################
  # Azure-related inputs
  ##########################################

  # Use the RG we created above instead of letting the module create one
  az_create_resource_group = false
  az_resource_group_name   = azurerm_resource_group.ignite.name

  # Azure region (must map to a supported ExpressRoute location in REGIONS.csv)
  az_region = var.azure_region

  # ExpressRoute peering config (demo-friendly values)
  az_exproute_peering_type          = "PRIVATE"       # or "MICROSOFT"
  az_exproute_peering_customer_asn  = var.az_peering_customer_asn
  az_exproute_peering_primary_address   = var.az_peering_primary_address   # e.g. 192.168.1.0/30
  az_exproute_peering_secondary_address = var.az_peering_secondary_address # e.g. 192.168.2.0/30
  az_exproute_peering_vlan_id           = var.az_peering_vlan_id
  az_exproute_peering_shared_key        = var.az_peering_shared_key

  # Optional custom circuit name and tags
  az_exproute_circuit_name = var.az_exproute_circuit_name
  az_tags                  = var.az_tags

  ##########################################
  # Equinix Fabric connection side
  ##########################################

  # REQUIRED: notification emails
  fabric_notification_users = var.fabric_notification_users

  # Connection naming & speed
  fabric_connection_name = var.fabric_connection_name
  fabric_speed           = var.fabric_speed  # Mbps

  # A-side: where the connection originates
  # One of these is typically set depending on your pattern:
  fabric_port_name          = var.fabric_port_name
  fabric_vlan_stag          = var.fabric_vlan_stag
  fabric_service_token_id   = var.fabric_service_token_id
  network_edge_device_id    = var.network_edge_device_id
  network_edge_device_interface_id = var.network_edge_device_interface_id

  # Redundancy
  redundancy_type              = var.redundancy_type          # "SINGLE" or "REDUNDANT"
  fabric_secondary_connection_name = var.fabric_secondary_connection_name
  fabric_secondary_port_name       = var.fabric_secondary_port_name
  fabric_secondary_vlan_stag       = var.fabric_secondary_vlan_stag
  fabric_secondary_service_token_id = var.fabric_secondary_service_token_id
  network_edge_secondary_device_id       = var.network_edge_secondary_device_id
  network_edge_secondary_device_interface_id = var.network_edge_secondary_device_interface_id

  # Optional: destination metro override (seller side).
  # When omitted, module maps from az_region using REGIONS.csv.
  fabric_destination_metro_code = var.fabric_destination_metro_code

  ##########################################
  # Optional BGP on Network Edge
  ##########################################
  network_edge_configure_bgp = var.network_edge_configure_bgp
}
