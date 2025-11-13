# Slide Deck Outline

This document provides talking points and content for 6-8 slides to accompany the demo.

---

## Slide 1: Title & Context

### Visual
- Title in large, bold text
- Ignite 2025 and Equinix logos
- Presenter name and role

### Content

**Title:**
"Hybrid Connectivity as Code: ExpressRoute + Equinix Fabric with Terraform and Copilot"

**Subtitle:**
Microsoft Ignite 2025 - Equinix Booth Demo

**Key Bullets:**
- ✓ Hybrid connectivity as code with Terraform
- ✓ ExpressRoute + Equinix Fabric pattern
- ✓ Live coding in VS Code with GitHub Copilot
- ✓ A repeatable pattern, not a full reference architecture

### Talking Points
- "Today we're showing how to turn hybrid connectivity into code"
- "This is a foundational pattern you can adapt and extend"
- "We'll code live with AI assistance to show the developer experience"

---

## Slide 2: The Problem - Hybrid Connectivity Today

### Visual
- Icons showing manual processes: tickets, spreadsheets, email chains
- Red highlights on pain points
- Clock icon emphasizing slowness

### Content

**Headline:**
"The Challenge: Manual, Slow, Hard to Repeat"

**Key Pain Points:**
- 📋 Manual tickets and spreadsheets
- 🔄 One-off configurations that can't be reused
- 🔍 Hard to audit or verify changes
- 🗑️ Difficult to tear down safely
- 🔧 Cloud and on-prem teams using different tools

**The Goal:**
> "We want network changes to look like code changes"

### Talking Points
- "Most organizations still handle ExpressRoute with tickets"
- "Configuration knowledge lives in spreadsheets and tribal knowledge"
- "When something breaks, you're archeology-ing through change logs"
- "What if we could treat this like application code?"

---

## Slide 3: Reference Architecture

### Visual
- Architecture diagram with three zones:
  1. Azure (left): VNet, Gateway, Circuit
  2. Connection (middle): Service key exchange
  3. Equinix (right): Fabric L2 connection

### Content

**Azure Side:**
- Virtual Network
- ExpressRoute Gateway
- ExpressRoute Circuit

**The Contract:**
- ExpressRoute is the connection agreement
- Service key links both sides
- Private L2 connectivity

**Equinix Side:**
- Fabric L2 Connection
- Metro location selection
- Bandwidth configuration

### Talking Points
- "Three main components working together"
- "Azure provides the circuit and gateway"
- "Equinix provides the physical connectivity through Fabric"
- "ExpressRoute service key is what ties them together"
- "All private, no internet exposure"

---

## Slide 4: Terraform Providers - azurerm + equinix

### Visual
- Two-column layout
- Left: Azure resources with azurerm provider
- Right: Equinix resources with equinix provider
- Center: Shared variables

### Content

**azurerm Provider:**
```hcl
provider "azurerm" {
  features {}
}
```
- Resource Group
- VNet + Gateway
- ExpressRoute Circuit

**equinix Provider:**
```hcl
provider "equinix" {
  # API credentials
}
```
- Fabric L2 Connection
- Metro + Bandwidth

**Shared Configuration:**
- Region ↔ Metro mapping
- Bandwidth alignment
- Environment naming

### Code Highlight
```hcl
variable "bandwidth_mbps" {
  description = "Circuit bandwidth"
  default     = 100
}

variable "equinix_metro" {
  description = "Metro code (SV, DC, etc.)"
  default     = "SV"
}
```

### Talking Points
- "Two providers working together seamlessly"
- "Variables keep configuration consistent"
- "Service key flows from Azure to Equinix"
- "One terraform apply creates the entire topology"

---

## Slide 5: Live Coding with GitHub Copilot

### Visual
- VS Code screenshot with Copilot suggestions
- Before/after code comparison
- Copilot chat interface visible

### Content

**The Workflow:**
1. Start from minimal scaffold
2. Use Copilot Agent Mode for natural language requests
3. Copilot generates variables, resources, comments
4. Iterate and refine in seconds

**Example Prompts:**
- ✍️ "Add a secondary Fabric connection when redundancy is enabled"
- 📝 "Add comments explaining the service key relationship"
- 🔧 "Change bandwidth to 500 Mbps and metro to DC"

**The Power:**
> "Infrastructure code that explains itself, co-authored with AI"

### Code Highlight
```hcl
# Before: Basic connection
resource "equinix_fabric_connection" "main" {
  # ...
}

# After: With Copilot's help
resource "equinix_fabric_connection" "primary" {
  # Primary connection to ExpressRoute
  # Uses service key for authentication
}

resource "equinix_fabric_connection" "secondary" {
  count = var.fabric_enable_redundancy ? 1 : 0
  # Secondary connection for HA
}
```

### Talking Points
- "Natural language becomes working infrastructure"
- "Copilot understands the pattern and extends it"
- "Documentation generated alongside the code"
- "Faster development, fewer errors, better understanding"

---

## Slide 6: Terraform Plan & Operational Benefits

### Visual
- Terminal screenshot showing `terraform plan` output
- Green + signs for resources to be created
- Pull request workflow diagram

### Content

**What `terraform plan` Shows:**
- Exact resources to be created/modified
- Dependencies and ordering
- Attribute values before apply
- No surprises

**Operational Wins:**
```
Developer commits → 
  PR created → 
    Automated plan → 
      Peer review → 
        Approved → 
          Pipeline applies
```

**Key Benefits:**
- ✅ Preview before apply
- 👥 Code review for infrastructure
- 📊 Audit trail in git history
- 🔄 Repeatable across environments

### Terminal Highlight
```
Terraform will perform the following actions:

  # azurerm_express_route_circuit.main will be created
  + resource "azurerm_express_route_circuit" "main" {
      + bandwidth_in_mbps = 100
      + service_key       = (known after apply)
      + service_provider  = "Equinix"
    }

  # equinix_fabric_connection.main will be created
  + resource "equinix_fabric_connection" "main" {
      + bandwidth         = 100
      + type              = "EVPL_VC"
      + metro_code        = "SV"
    }

Plan: 8 to add, 0 to change, 0 to destroy.
```

### Talking Points
- "Every change is visible before it happens"
- "Pull requests for network changes, just like app code"
- "Compliance and audit requirements met automatically"
- "Same pattern works in dev, test, and production"

---

## Slide 7: Extending the Pattern

### Visual
- Branching diagram showing different extension paths
- Icons for multi-region, hub-spoke, modules

### Content

**Scale Horizontally:**
- 🌍 Multiple regions with their own circuits
- 🏢 Multiple VNets using the same circuit
- 🔄 Hub-and-spoke topologies

**Scale Vertically:**
- 📦 Package as Terraform modules
- 🔧 Integrate with CI/CD pipelines
- 👥 Add approval workflows
- 📊 Cost allocation and tagging

**Where to Find More:**
- Equinix Labs GitHub repositories
- Azure reference architectures
- Terraform Registry modules

### Example Extensions
```hcl
# Multi-region deployment
module "west_coast" {
  source = "./modules/expressroute-fabric"
  region = "westus2"
  metro  = "SV"
}

module "east_coast" {
  source = "./modules/expressroute-fabric"
  region = "eastus2"
  metro  = "DC"
}
```

### Talking Points
- "This is a building block, not the entire building"
- "Add regions, VNets, redundancy as needed"
- "Modularize for your organization"
- "Integrate with your existing pipelines"

---

## Slide 8: Call to Action

### Visual
- Large QR code (center)
- Contact information
- Links to resources
- "Thank you" message

### Content

**Try It Yourself:**
📱 Scan the QR code to get:
- Sample Terraform repository
- GitHub Copilot prompts
- Step-by-step guide
- Architecture documentation

**Experiment:**
- Use your own Azure subscription
- Try different metros and bandwidth
- Add redundancy and multi-region
- Integrate with your workflows

**Talk to Us About:**
- Migrating manual ExpressRoute configs to Terraform
- Adding more regions/topologies with Equinix Fabric
- Your specific hybrid connectivity challenges
- CI/CD integration patterns

**Learn More:**
- 📚 docs.microsoft.com/azure/expressroute
- 📚 docs.equinix.com/fabric
- 💻 github.com/equinix-labs
- 💬 Stop by the booth anytime!

### Talking Points
- "Everything you need to try this is in the repo"
- "We're here to help with your specific scenarios"
- "Whether you're just starting with ExpressRoute or scaling to dozens of regions"
- "Let's talk about how this pattern fits your needs"

---

## Backup Slides

### Backup Slide 1: Cost Considerations

**ExpressRoute Costs:**
- Circuit fee (monthly, bandwidth-based)
- Gateway cost (hourly, SKU-based)
- Data transfer (outbound from Azure)

**Equinix Fabric Costs:**
- Connection fee (bandwidth and metro)
- Port fees (if dedicated)

**Optimization Tips:**
- Start small, scale up
- Use Standard SKU for regional connectivity
- Right-size gateway and bandwidth
- Monitor with Azure Cost Management

### Backup Slide 2: Prerequisites

**What You Need:**
- Azure subscription with permissions
- Equinix Fabric account
- Terraform installed (v1.0+)
- VS Code with GitHub Copilot
- Basic understanding of:
  - Azure VNets
  - Private connectivity concepts
  - Terraform basics (helpful but not required)

### Backup Slide 3: Troubleshooting

**Common Issues:**
- Circuit not provisioning → Check service key
- No connectivity → Verify BGP status
- Performance issues → Review bandwidth settings

**Where to Get Help:**
- Azure Support for ExpressRoute
- Equinix Support for Fabric
- GitHub Issues in the sample repo
- Community forums

---

## Presentation Tips

### Timing
- Each slide: 2-3 minutes
- Allow time for questions throughout
- Keep demo section flexible (5-10 min)

### Engagement
- Ask audience about their current connectivity approach
- Pause for questions on architecture slide
- Live poll: "Who's used ExpressRoute? Equinix Fabric?"

### Technical Checks
- Test QR code before presentation
- Have slide deck backed up locally
- Verify all code samples render correctly
- Test transitions and animations

### Handoffs
If co-presenting:
- Intro/problem: Speaker 1
- Architecture/code: Speaker 2  
- Demo: Either or both
- Wrap-up: Speaker 1

---

**Remember**: These slides support your demo, they don't replace it. Focus on showing the live coding experience and the value of treating connectivity as code.
