# Terraform Configuration for Azure ExpressRoute + Equinix Fabric Demo
# Microsoft Ignite 2025

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    equinix = {
      source  = "equinix/equinix"
      version = "~> 1.14"
    }
  }
}

# Azure Provider Configuration
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

# Equinix Provider Configuration
provider "equinix" {
  # Authentication via environment variables:
  # EQUINIX_API_CLIENTID
  # EQUINIX_API_CLIENTSECRET
}

# Azure Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.env_name}-rg"
  location = var.azure_region
  tags     = var.az_tags
}

# Azure Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.env_name}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.az_tags
}

# Gateway Subnet (required for ExpressRoute Gateway)
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP for ExpressRoute Gateway
resource "azurerm_public_ip" "gateway" {
  name                = "${var.env_name}-gateway-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.az_tags
}

# ExpressRoute Gateway
resource "azurerm_virtual_network_gateway" "expressroute" {
  name                = "${var.env_name}-er-gateway"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  type                = "ExpressRoute"
  sku                 = "Standard"

  ip_configuration {
    name                          = "gateway-ip-config"
    public_ip_address_id          = azurerm_public_ip.gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }

  tags = var.az_tags
}

# Azure ExpressRoute Circuit
# This creates the Azure-side contract for private connectivity
# The service key generated here will be used by Equinix to establish the physical connection
resource "azurerm_express_route_circuit" "main" {
  name                  = var.az_exproute_circuit_name
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  service_provider_name = "Equinix"
  peering_location      = var.fabric_destination_metro_code
  bandwidth_in_mbps     = var.fabric_speed

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags = var.az_tags
}

# Note: Equinix Fabric Connection would go here
# This requires the service key from the ExpressRoute circuit above
# For a fully working example, you would add:
# 
# resource "equinix_fabric_connection" "azure" {
#   name = var.fabric_connection_name
#   type = "EVPL_VC"
#   
#   notifications {
#     type   = "ALL"
#     emails = var.fabric_notification_users
#   }
#
#   bandwidth = var.fabric_speed
#   
#   order {
#     purchase_order_number = var.env_name
#   }
#
#   a_side {
#     # Your Equinix connection point (port, service token, or Network Edge)
#   }
#
#   z_side {
#     # Azure ExpressRoute
#     service_token = azurerm_express_route_circuit.main.service_key
#   }
# }

# Connection between Gateway and Circuit
resource "azurerm_virtual_network_gateway_connection" "expressroute" {
  name                = "${var.env_name}-er-connection"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  type                       = "ExpressRoute"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.expressroute.id
  express_route_circuit_id   = azurerm_express_route_circuit.main.id

  tags = var.az_tags
}
