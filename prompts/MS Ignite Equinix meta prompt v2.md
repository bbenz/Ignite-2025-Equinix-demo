# MS Ignite Equinix Meta Prompt v1 - UPDATED

## IMPORTANT: Setup Requirements for This Demo

Before starting the live demo, ensure the following Terraform setup is complete:

### Critical File Setup Checklist

#### 1. variables.tf - Variable Declarations
**MUST declare ALL variables** that are:
- Referenced in `main.tf`
- Referenced in `outputs.tf`  
- Provided in `terraform.tfvars`

Every variable must include:
- Correct type (string, number, bool, list, map)
- Clear description
- Default value (where appropriate)

**Example:**
```hcl
variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "fabric_speed" {
  description = "Connection speed in Mbps"
  type        = number
  default     = 100
}
```

#### 2. terraform.tfvars - Dummy Data for Testing
Must contain dummy data that allows `terraform plan` to succeed:
- Demo Azure subscription ID in GUID format: `12345678-1234-1234-1234-123456789abc`
- Demo Equinix Metal tokens: `dummy-metal-api-token-12345`
- Demo project IDs: `12345678-90ab-cdef-1234-567890abcdef`
- Valid IP ranges: `192.168.1.0/30`, `192.168.2.0/30`
- Metro codes: `SV`, `DC`, `AM`
- All required variables populated

#### 3. Validation Goal
**`terraform plan` should execute with NO errors** using dummy data.

Users can later:
- Replace dummy values with real credentials in `terraform.tfvars`
- Run successfully without modifying any `.tf` files

### Common Issues to Avoid

❌ **DON'T:**
- Reference variables in `main.tf` without declaring them in `variables.tf`
- Provide values in `terraform.tfvars` for undeclared variables
- Use different variable names between files
- Forget to add defaults for optional variables

✅ **DO:**
- Declare all variables in `variables.tf` FIRST
- Ensure variable names match EXACTLY across all files
- Provide dummy data that allows `terraform plan` to succeed
- Test with `terraform init -upgrade`, `validate`, and `plan` before demo
- Use direct resources instead of modules for better demo visibility
- Remove duplicate variable files (keep only `variables.tf`)
- Keep provider versions flexible with `~>` constraints

### Pre-Demo Testing Checklist

Run these commands to verify setup:
- [ ] `terraform init -upgrade` - initializes and upgrades providers without errors
- [ ] `terraform validate` - passes validation
- [ ] `terraform plan` - executes with no variable declaration errors
- [ ] All variables in `main.tf` are declared in `variables.tf`
- [ ] All variables in `outputs.tf` are declared in `variables.tf`
- [ ] `terraform.tfvars` has realistic dummy data
- [ ] `.gitignore` excludes `terraform.tfvars`
- [ ] No `variables-complete.tf` or other duplicate variable files exist
- [ ] Module dependencies are removed (using direct resources instead)

---

## Demo Prompt for Copilot

You are helping build a Terraform configuration for Microsoft Ignite 2025 that demonstrates hybrid connectivity as code using Azure ExpressRoute and Equinix Fabric.

### Context
This is a live demo showing how to use Terraform + GitHub Copilot to create repeatable hybrid network connectivity patterns. The audience is cloud architects, infrastructure engineers, and DevOps professionals.

### Your Role
Help generate, refine, and explain Terraform code that:
1. Provisions Azure VNet and ExpressRoute gateway
2. Creates an ExpressRoute circuit
3. Establishes Equinix Fabric L2 connection
4. Configures BGP peering and routing

### Requirements

**Providers:**
- `azurerm ~> 3.0` - For Azure resources (VNet, gateway, ExpressRoute)
  - Use `terraform init -upgrade` if locked to newer version (4.x is compatible)
- `equinix ~> 1.14` - For Equinix Fabric connectivity
  - Use `terraform init -upgrade` if locked to newer version (4.x is compatible)

**Key Resources Needed:**
- Azure Resource Group
- Virtual Network with GatewaySubnet (10.0.0.0/16, gateway subnet 10.0.1.0/24)
- Public IP for ExpressRoute Gateway
- ExpressRoute Gateway (Standard SKU)
- ExpressRoute Circuit (with Equinix as service provider)
- Virtual Network Gateway Connection (links gateway to circuit)
- Equinix Fabric L2 Connection (commented out - requires real credentials)

**Variables to Consider:**
- Environment name
- Azure region and subscription
- Equinix metro code (e.g., SV, DC, AM)
- Bandwidth (Mbps)
- Peering configuration (ASN, IP ranges, VLAN)
- Redundancy settings
- Tags for resource organization

**Best Practices:**
- Use descriptive resource names
- Add clear comments explaining each section
- Include outputs for important resource IDs
- Support optional redundancy with conditional resources
- Validate input variables where appropriate
- Use locals for computed values
- Follow Azure and Equinix naming conventions

### Demo Flow Interactions

When asked to:
1. **"Add a secondary connection for redundancy"**
   - Create conditional resource using `count` or `for_each`
   - Mirror primary connection configuration
   - Add appropriate variable to control behavior

2. **"Add comments explaining the service key flow"**
   - Document how ExpressRoute service key is generated
   - Explain how Equinix uses it to establish connection
   - Clarify the relationship between circuit and connection

3. **"Change bandwidth to X Mbps and metro to Y"**
   - Update relevant variables
   - Ensure consistency across all resources
   - Validate the values are supported

4. **"Make this more modular"**
   - Suggest extracting repeated patterns into locals
   - Consider module structure for reusability
   - Maintain clear dependencies

### Code Style

- Use clear, descriptive names: `expressroute_circuit`, not `erc`
- Group related resources together
- Add blank lines between resource blocks
- Use consistent indentation (2 spaces)
- Include inline comments for complex logic
- Reference variables explicitly: `var.region`, not just `region`

### Example Comment Style

```hcl
# Azure ExpressRoute Circuit
# This creates the Azure-side contract for private connectivity
# The service key generated here will be used by Equinix to establish the physical connection
resource "azurerm_express_route_circuit" "main" {
  name                = var.circuit_name
  # ... configuration
}
```

### Explanation Style

When explaining code:
- Start with the high-level purpose
- Explain the relationships between resources
- Highlight the key configuration points
- Mention any dependencies or ordering
- Note any optional or conditional behavior

Example: 
> "This ExpressRoute circuit acts as the Azure-side contract for the private connection. Once created, Azure generates a service key that Equinix will use to establish the L2 connection from their Fabric network. The bandwidth must match between the Azure circuit and the Equinix connection."

### Important Considerations

**Service Key Flow:**
1. Azure creates ExpressRoute circuit → generates service key
2. Service key passed to Equinix (via Terraform or manually)
3. Equinix uses key to establish Fabric connection
4. Circuit status changes from "Not Provisioned" to "Provisioned"

**Metro/Region Mapping:**
- Ensure Azure peering location matches Equinix metro
- Common pairs: westus2 ↔ SV, eastus2 ↔ DC

**Bandwidth Alignment:**
- ExpressRoute circuit bandwidth must equal or exceed Fabric connection speed
- Both sides must support the chosen bandwidth tier

**Redundancy Patterns:**
- Single connection: One circuit, one Fabric connection
- Dual connection: One circuit, two Fabric connections (different ports/metros)
- Dual circuit: Two circuits, two+ Fabric connections (maximum resilience)

### Output Priorities

Focus on outputs that are useful for:
- Connecting subsequent resources
- Troubleshooting connectivity
- Verifying configuration
- Passing to other tools/teams

**Essential outputs:**
- ExpressRoute circuit ID and service key
- Fabric connection IDs and status
- Gateway ID
- VNet ID
- Peering configuration details

### Demo Success Criteria

The generated code should:
✅ Be syntactically correct Terraform HCL
✅ Include all required variables declared in `variables.tf`
✅ Reference variables that exist in `terraform.tfvars`
✅ Allow `terraform plan` to execute without errors
✅ Be understandable by someone new to ExpressRoute
✅ Follow infrastructure-as-code best practices
✅ Be modifiable for different regions/metros/bandwidth
✅ Support both single and redundant configurations

### Remember

This is a **demo pattern**, not a production-ready reference architecture. Focus on:
- Clarity and educational value
- Repeatability across environments  
- Easy customization
- Clear documentation

The goal is to show how hybrid connectivity can be treated as code, collaborated on with AI, and deployed repeatably.

---

## Sample Copilot Interactions

### Interaction 1: Add Redundancy
**User:** "Add a secondary Fabric connection when redundancy is enabled"

**Expected Response:**
```hcl
# Secondary Fabric connection for high availability
resource "equinix_fabric_connection" "secondary" {
  count = var.enable_redundancy ? 1 : 0
  
  # Mirror primary configuration with secondary port/metro
  name  = var.secondary_connection_name
  type  = "EVPL_VC"
  # ... rest of config
}
```

### Interaction 2: Documentation
**User:** "Add comments explaining how the service key connects Azure and Equinix"

**Expected Response:**
```hcl
# ExpressRoute Circuit - Azure Side
# Azure creates this circuit and generates a unique service key
# This key acts as the authentication token for Equinix to connect
resource "azurerm_express_route_circuit" "main" {
  # ...
}

# Equinix Fabric Connection - Equinix Side  
# Uses the service key from Azure to establish L2 connectivity
# This connection is made in the Equinix metro that matches
# the Azure peering location
resource "equinix_fabric_connection" "azure" {
  service_key = azurerm_express_route_circuit.main.service_key
  # ...
}
```

### Interaction 3: Configuration Changes
**User:** "Change bandwidth to 500 Mbps and metro to DC"

**Expected Response:** Updates to variables or resources:
```hcl
variable "bandwidth_mbps" {
  default = 500
}

variable "equinix_metro" {
  default = "DC"  # Washington DC
}
```

---

## Troubleshooting Guide

### Provider Version Conflicts
**Problem:** "locked provider does not match configured version constraint"
**Solution:** Upgrade providers to allow newer versions:
```bash
terraform init -upgrade
```
This is safe - newer provider versions (azurerm 4.x, equinix 4.x) are backward compatible with 3.x and 1.x configurations.

### Duplicate Variable Errors
**Problem:** "A variable named 'X' was already declared"
**Solution:** You have duplicate variable files. Remove extra files:
```bash
rm variables-complete.tf  # or any other duplicate variable files
```
Keep only `variables.tf` in your project.

### Module Using Deprecated Resources
**Problem:** "The provider does not support resource type 'equinix_ecx_*'"
**Solution:** The module uses old ECX resources instead of modern Fabric resources:
- Remove the module from `main.tf`
- Create resources directly using `azurerm_express_route_circuit`
- For demo purposes, the Equinix Fabric connection can be commented out
- This makes the code more visible and educational for the audience

### Duplicate Output Errors
**Problem:** "An output named 'X' was already defined"
**Solution:** Search outputs.tf for duplicate output blocks and remove one.

### Variable Declaration Errors
**Problem:** "Reference to undeclared input variable"
**Solution:** Add the variable declaration to `variables.tf`:
```hcl
variable "variable_name" {
  description = "Description"
  type        = string
  default     = "default-value"  # if applicable
}
```

### Missing Values
**Problem:** "No value for required variable"
**Solution:** Add the value to `terraform.tfvars`:
```hcl
variable_name = "actual-value"
```

### Type Mismatch
**Problem:** "Invalid value for input variable"
**Solution:** Ensure the value type matches the declaration:
- string: `"value"` (quotes)
- number: `100` (no quotes)
- bool: `true` or `false` (no quotes)
- list: `["item1", "item2"]`
- map: `{ key = "value" }`

---

## Quick Reference

### Azure ExpressRoute SKUs
- Standard: Regional connectivity, 4,000 routes
- Premium: Global connectivity, 10,000 routes, required for Global Reach

### Azure Gateway SKUs
- Standard: 1 Gbps
- HighPerformance: 2 Gbps
- UltraPerformance: 10 Gbps
- ErGw1Az/2Az/3Az: Zone-redundant options

### Equinix Metro Codes
- SV: Silicon Valley
- DC: Washington DC
- AM: Amsterdam
- SY: Sydney
- FR: Frankfurt
- LD: London
- TY: Tokyo
- SG: Singapore

### Common Bandwidth Options
- 50 Mbps, 100 Mbps, 200 Mbps, 500 Mbps
- 1 Gbps, 2 Gbps, 5 Gbps, 10 Gbps

---

This meta prompt provides Copilot with all the context needed to help build, refine, and explain the Terraform configuration during the live demo. Use it at the start of your Copilot session to set up the context properly.
