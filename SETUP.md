# Quick Setup Guide

## Step 1: Add Missing Variables to variables.tf

Your `variables.tf` file needs to be updated with all the required variable declarations. Add this content at the end of your existing `variables.tf`:

```hcl
# Azure Configuration
variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_region" {
  description = "Azure region (e.g., westus2, eastus2)"
  type        = string
  default     = "westus2"
}

variable "az_exproute_circuit_name" {
  description = "Name of the ExpressRoute circuit"
  type        = string
  default     = "ignite-demo-expressroute"
}

variable "az_tags" {
  description = "Tags to apply to Azure resources"
  type        = map(string)
  default = {
    Environment = "Demo"
    Project     = "Ignite2025"
  }
}

# Azure ExpressRoute Peering Configuration
variable "az_peering_customer_asn" {
  description = "Customer ASN for BGP peering"
  type        = number
  default     = 65000
}

variable "az_peering_primary_address" {
  description = "Primary peer address block (e.g., 192.168.1.0/30)"
  type        = string
  default     = "192.168.1.0/30"
}

variable "az_peering_secondary_address" {
  description = "Secondary peer address block (e.g., 192.168.2.0/30)"
  type        = string
  default     = "192.168.2.0/30"
}

variable "az_peering_vlan_id" {
  description = "VLAN ID for ExpressRoute peering"
  type        = number
  default     = 100
}

variable "az_peering_shared_key" {
  description = "Shared key for BGP authentication"
  type        = string
  sensitive   = true
  default     = ""
}

# Equinix Fabric Configuration
variable "fabric_notification_users" {
  description = "List of email addresses for Fabric notifications"
  type        = list(string)
  default     = []
}

variable "fabric_connection_name" {
  description = "Name of the primary Fabric connection"
  type        = string
  default     = "ignite-demo-fabric-primary"
}

variable "fabric_speed" {
  description = "Connection speed in Mbps"
  type        = number
  default     = 100
}

variable "fabric_destination_metro_code" {
  description = "Equinix metro code (e.g., SV, DC, AM)"
  type        = string
  default     = "SV"
}

variable "fabric_metro_code" {
  description = "Equinix metro code for outputs"
  type        = string
  default     = "SV"
}

variable "fabric_bandwidth_mbps" {
  description = "Fabric bandwidth in Mbps for outputs"
  type        = number
  default     = 100
}

# Fabric Connection Options (choose one method)
variable "fabric_port_name" {
  description = "Fabric port name (if using dedicated port)"
  type        = string
  default     = ""
}

variable "fabric_vlan_stag" {
  description = "VLAN S-TAG for primary connection (if using port)"
  type        = number
  default     = null
}

variable "fabric_service_token_id" {
  description = "Service token ID (if using service token)"
  type        = string
  default     = ""
}

variable "network_edge_device_id" {
  description = "Network Edge device ID (if using Network Edge)"
  type        = string
  default     = ""
}

variable "network_edge_device_interface_id" {
  description = "Network Edge device interface ID"
  type        = string
  default     = ""
}

variable "network_edge_configure_bgp" {
  description = "Whether to configure BGP on Network Edge device"
  type        = bool
  default     = false
}

# Redundancy Configuration
variable "redundancy_type" {
  description = "Redundancy type: SINGLE or REDUNDANT"
  type        = string
  default     = "SINGLE"
  validation {
    condition     = contains(["SINGLE", "REDUNDANT"], var.redundancy_type)
    error_message = "Redundancy type must be SINGLE or REDUNDANT."
  }
}

variable "fabric_secondary_connection_name" {
  description = "Name of the secondary Fabric connection (for redundancy)"
  type        = string
  default     = "ignite-demo-fabric-secondary"
}

variable "fabric_secondary_port_name" {
  description = "Secondary fabric port name (if using dedicated port)"
  type        = string
  default     = ""
}

variable "fabric_secondary_vlan_stag" {
  description = "VLAN S-TAG for secondary connection"
  type        = number
  default     = null
}

variable "fabric_secondary_service_token_id" {
  description = "Secondary service token ID"
  type        = string
  default     = ""
}

variable "network_edge_secondary_device_id" {
  description = "Secondary Network Edge device ID"
  type        = string
  default     = ""
}

variable "network_edge_secondary_device_interface_id" {
  description = "Secondary Network Edge device interface ID"
  type        = string
  default     = ""
}
```

## Step 2: Create terraform.tfvars

Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then edit `terraform.tfvars` with your actual values. At minimum, you need:

```hcl
azure_subscription_id = "your-actual-subscription-id"
metal_auth_token      = "your-equinix-metal-token"
metal_project_id      = "your-equinix-project-id"
```

## Step 3: Initialize Terraform

```bash
terraform init
```

## Step 4: Validate Configuration

```bash
terraform validate
```

## Step 5: Plan Your Deployment

```bash
terraform plan
```

## Step 6: Apply (when ready)

```bash
terraform apply
```

## Quick Commands

```bash
# Just to fix the variable errors for now:
# 1. Open variables.tf in your editor
# 2. Copy the variable declarations above
# 3. Paste at the end of the file
# 4. Save

# Then run:
terraform init
terraform validate
```
