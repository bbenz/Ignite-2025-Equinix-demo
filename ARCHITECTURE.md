# Architecture Overview

This document provides detailed information about the ExpressRoute + Equinix Fabric connectivity pattern.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Azure                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                    Virtual Network                    │  │
│  │  ┌────────────┐         ┌──────────────────────┐    │  │
│  │  │ Workloads  │         │ ExpressRoute Gateway │    │  │
│  │  └────────────┘         └──────────┬───────────┘    │  │
│  └────────────────────────────────────┼────────────────┘  │
│                                        │                   │
│                          ┌─────────────▼────────────┐      │
│                          │  ExpressRoute Circuit    │      │
│                          │  (Service Key)           │      │
│                          └─────────────┬────────────┘      │
└────────────────────────────────────────┼───────────────────┘
                                         │
                            ═════════════╪═════════════
                                    Private Link
                            ═════════════╪═════════════
                                         │
┌────────────────────────────────────────┼───────────────────┐
│                      Equinix                                │
│                          ┌─────────────▼────────────┐      │
│                          │  Fabric L2 Connection    │      │
│                          │  (Metro: SV, DC, etc.)   │      │
│                          └─────────────┬────────────┘      │
│                                        │                   │
│  ┌────────────────────────────────────┼────────────────┐  │
│  │                  Customer Edge                       │  │
│  │  ┌──────────────────┐         ┌──────────────────┐ │  │
│  │  │  On-Prem Network │         │  Colo Resources  │ │  │
│  │  └──────────────────┘         └──────────────────┘ │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Component Details

### Azure Components

#### 1. Virtual Network (VNet)
- **Purpose**: Logical isolation for Azure resources
- **Configuration**:
  - Address space (e.g., 10.0.0.0/16)
  - Subnets for workloads and gateway
  - GatewaySubnet for ExpressRoute gateway (required)

#### 2. ExpressRoute Gateway
- **Purpose**: Azure's gateway to private connections
- **SKU Options**:
  - Standard: 1 Gbps
  - HighPerformance: 2 Gbps
  - UltraPerformance: 10 Gbps
  - ErGw1Az, ErGw2Az, ErGw3Az: Zone-redundant options
- **Connection Type**: ExpressRoute (not VPN)

#### 3. ExpressRoute Circuit
- **Purpose**: The contract for private connectivity
- **Key Properties**:
  - Service Provider: Equinix
  - Peering Location: Must match Equinix metro
  - Bandwidth: 50 Mbps to 10 Gbps
  - Service Key: Used by Equinix to establish connection
  - SKU: Standard or Premium
    - Standard: Regional connectivity
    - Premium: Global reach, more routes

### Equinix Components

#### 1. Fabric L2 Connection
- **Purpose**: Layer 2 connectivity to Azure ExpressRoute
- **Configuration**:
  - Metro location (e.g., SV = Silicon Valley, DC = Washington DC)
  - Bandwidth (must match or be less than ExpressRoute circuit)
  - VLAN tagging for traffic isolation
  - Service key from ExpressRoute circuit
  - Connection type: Cloud Router or dedicated port

#### 2. Metros and Peering Locations
- **Metro**: Equinix's data center location
- **Peering Location**: Where Azure ExpressRoute is available
- **Common Mappings**:
  - SV (Silicon Valley) → Silicon Valley peering
  - DC (Washington DC) → Washington DC peering
  - AM (Amsterdam) → Amsterdam peering
  - SY (Sydney) → Sydney peering

### The Connection Flow

1. **Azure Creates ExpressRoute Circuit**
   - Terraform provisions circuit in Azure
   - Azure generates service key
   - Circuit is in "NotProvisioned" state

2. **Equinix Establishes L2 Connection**
   - Uses service key to identify circuit
   - Creates Fabric connection in specified metro
   - Configures bandwidth and VLAN

3. **Circuit Becomes Provisioned**
   - Azure detects Equinix connection
   - Circuit state changes to "Provisioned"
   - BGP sessions established

4. **Gateway Connection**
   - ExpressRoute gateway connects to circuit
   - Routes exchanged via BGP
   - VNet resources can reach on-prem

## Terraform Providers

**azurerm Provider (~> 3.0, compatible with 4.x)**

**Purpose**: Manage Azure resources

**Key Resources Used**:
- `azurerm_resource_group`: Container for resources
- `azurerm_virtual_network`: VNet definition (10.0.0.0/16)
- `azurerm_subnet`: GatewaySubnet (10.0.1.0/24 - required name)
- `azurerm_public_ip`: Static public IP for ExpressRoute gateway
- `azurerm_virtual_network_gateway`: ExpressRoute gateway (Standard SKU)
- `azurerm_express_route_circuit`: The ExpressRoute circuit with service key
- `azurerm_virtual_network_gateway_connection`: Links gateway to circuit

**Authentication**:
- Azure CLI
- Service Principal
- Managed Identity

**equinix Provider (~> 1.14, compatible with 4.x)**

**Purpose**: Manage Equinix Fabric resources

**Key Resources Used**:
- `equinix_fabric_connection`: L2 connection to Azure (commented out in demo)
- Note: Requires actual Equinix credentials and port/service token setup

**Authentication**:
- Environment variables: `EQUINIX_API_CLIENTID` and `EQUINIX_API_CLIENTSECRET`
- Or via Terraform variables (not recommended for sensitive data)

**Demo Note**: The Fabric connection is shown as a commented placeholder in the demo code. Full implementation requires:
- Active Equinix Fabric account
- Available port or service token
- Actual service key from ExpressRoute circuit

## Variables and Configuration

### Essential Variables

```hcl
variable "environment" {
  description = "Environment name (e.g., ignite-demo)"
  type        = string
}

variable "azure_region" {
  description = "Azure region (e.g., westus2)"
  type        = string
}

variable "equinix_metro" {
  description = "Equinix metro code (e.g., SV, DC)"
  type        = string
}

variable "bandwidth_mbps" {
  description = "Bandwidth in Mbps (e.g., 50, 100, 500)"
  type        = number
}

variable "fabric_enable_redundancy" {
  description = "Enable secondary Fabric connection"
  type        = bool
  default     = false
}
```

### Computed Outputs

```hcl
output "expressroute_circuit_id" {
  description = "ID of the ExpressRoute circuit"
  value       = azurerm_express_route_circuit.main.id
}

output "expressroute_service_key" {
  description = "Service key for Equinix connection"
  value       = azurerm_express_route_circuit.main.service_key
  sensitive   = true
}

output "fabric_connection_status" {
  description = "Status of Equinix Fabric connection"
  value       = equinix_fabric_connection.main.status
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}
```

## Resource Dependencies

Understanding the dependency chain is critical for Terraform to create resources in the correct order:

```
1. Resource Group
   └─> Virtual Network
       └─> Subnets (including GatewaySubnet)
           └─> Public IP
               └─> ExpressRoute Gateway
                   └─> ExpressRoute Circuit
                       ├─> Gateway Connection
                       └─> Equinix Fabric Connection
```

**Why this matters**:
- Gateway requires GatewaySubnet to exist
- Fabric connection requires service key from circuit
- Gateway connection requires both gateway and circuit

## Redundancy Patterns

### Single Connection (Basic)
- One ExpressRoute circuit
- One Equinix Fabric connection
- Cost-effective for dev/test

### Dual Connection (High Availability)
- One ExpressRoute circuit
- Two Equinix Fabric connections
- Different ports or metros recommended
- Circuit bandwidth shared

### Dual Circuit (Maximum Resilience)
- Two ExpressRoute circuits
- Two or four Fabric connections
- Different peering locations
- Can survive complete metro failure

## Security Considerations

### Network Isolation
- Private connectivity (no internet exposure)
- VLAN tagging for traffic separation
- BGP authentication via shared secrets

### Access Control
- Azure RBAC for resource management
- Equinix API token security
- Terraform state encryption

### Secrets Management
- Service keys stored in outputs (marked sensitive)
- Use Azure Key Vault for production
- Never commit secrets to version control

## Cost Optimization

### ExpressRoute Costs
- **Circuit cost**: Fixed monthly fee based on bandwidth
- **Data transfer**: Outbound data from Azure
- **Gateway cost**: Hourly charge based on SKU

**Optimization tips**:
- Start with lower bandwidth, scale up as needed
- Use Standard SKU for regional connectivity
- Consider Unlimited data plan for high transfer

### Equinix Fabric Costs
- **Connection fee**: Based on speed and metro
- **Cross-connect fees**: If using dedicated port
- **Metro pair pricing**: Some connections cost more

**Optimization tips**:
- Right-size bandwidth to actual needs
- Consider shared port vs. dedicated
- Review metro pricing differences

## Extending the Pattern

### Multi-Region Deployment

Add additional regions with their own ExpressRoute circuits:

```hcl
module "connectivity_west" {
  source         = "./modules/expressroute-fabric"
  azure_region   = "westus2"
  equinix_metro  = "SV"
  bandwidth_mbps = 500
}

module "connectivity_east" {
  source         = "modules/expressroute-fabric"
  azure_region   = "eastus2"
  equinix_metro  = "DC"
  bandwidth_mbps = 500
}
```

### Hub-and-Spoke Topology

Connect multiple VNets through VNet peering:

```
ExpressRoute Circuit
        │
        └─> Hub VNet
            ├─> Spoke VNet 1 (workload)
            ├─> Spoke VNet 2 (workload)
            └─> Spoke VNet 3 (workload)
```

**Benefits**:
- Centralized connectivity management
- Shared ExpressRoute circuit
- Cost-effective scaling

### Global Reach

Connect on-prem locations in different regions:

```
On-Prem West <─> ExpressRoute <─> Azure West
                      │
                Global Reach
                      │
On-Prem East <─> ExpressRoute <─> Azure East
```

**Requirements**:
- ExpressRoute Premium SKU
- Both circuits in Global Reach supported locations

### Integration with SD-WAN

Use Equinix Network Edge for SD-WAN integration:

```
Remote Sites ─> SD-WAN ─> Equinix Fabric ─> ExpressRoute ─> Azure
```

## Monitoring and Operations

### Key Metrics to Monitor
- Circuit availability
- BGP session status  
- Bandwidth utilization
- Route advertisements
- Connection health

### Azure Monitor Integration
- Alert on circuit down
- Track bandwidth utilization
- Log route changes
- Integration with Azure Sentinel

### Operational Runbooks
1. Circuit provisioning
2. Failover testing
3. Bandwidth upgrades
4. Circuit decommissioning

## Troubleshooting Guide

### Circuit Not Provisioning
- **Check**: Service key accuracy
- **Check**: Metro/peering location match
- **Check**: Equinix connection status
- **Resolution**: Verify all IDs and locations

### No Connectivity After Provisioning
- **Check**: BGP peering status
- **Check**: Route advertisements
- **Check**: Gateway connection state
- **Resolution**: Review BGP configuration

### Performance Issues
- **Check**: Bandwidth utilization
- **Check**: Route path (unexpected hops)
- **Check**: Gateway SKU capacity
- **Resolution**: Scale bandwidth or gateway

## Best Practices

### Configuration Management
- Use Terraform workspaces for environments
- Store state in Azure Storage with locking
- Implement code review for all changes
- Tag all resources consistently

### Security
- Rotate API credentials regularly
- Use managed identities where possible
- Implement least-privilege access
- Enable Azure Security Center

### Reliability
- Test failover procedures regularly
- Implement redundancy for production
- Monitor SLAs and availability
- Document recovery procedures

### Cost Management
- Right-size resources for actual needs
- Use Azure Cost Management + Billing
- Implement resource tagging for showback
- Review and optimize quarterly

## Additional Resources

### Documentation
- [Azure ExpressRoute Overview](https://docs.microsoft.com/azure/expressroute/)
- [Equinix Fabric Documentation](https://docs.equinix.com/fabric/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Equinix Provider](https://registry.terraform.io/providers/equinix/equinix/latest/docs)

### Sample Code
- [Equinix Labs on GitHub](https://github.com/equinix-labs)
- [Azure QuickStart Templates](https://github.com/Azure/azure-quickstart-templates)
- [Terraform Azure Examples](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples)

### Community
- [Equinix Community](https://community.equinix.com/)
- [Azure Architecture Center](https://docs.microsoft.com/azure/architecture/)
- [HashiCorp Discuss](https://discuss.hashicorp.com/)

---

This architecture provides a foundation for enterprise-grade hybrid connectivity that is repeatable, auditable, and scalable.
